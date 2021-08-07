if __name__ is not None and "." in __name__:
    from .ExprParser import ExprParser
    from .ExprVisitor import ExprVisitor
    from .ExprLexer import ExprLexer
    from polygons import *

else:
    from .ExprParser import ExprParser
    from .ExprVisitor import ExprVisitor
    from .ExprLexer import ExprLexer
    from polygons import *

from antlr4 import *

def str2parse(calc, comanda: str):

    input_stream = InputStream(comanda)
    lexer = ExprLexer(input_stream)
    token_stream = CommonTokenStream(lexer)
    parser = ExprParser(token_stream)
    tree = parser.root()
    return calc.visit(tree)

def changeFormat(p1, value = False):
    if not value:
        l = []
        for i in p1:
            for j in i:
                l.append("{:.3f}".format(j))
        result = l
    else:
        result = "{:.3f}".format(p1)
    return str(result)

# s'assumeix que tots els inputs seran vàlids tal i com s'indica a l'enunciat
def transbool(bool):
    if bool == 1:
        return "yes"
    else:
        return "no"

def replace (result):
    result = result.replace('[', '')
    result = result.replace(']', '')
    result = result.replace(',', '')
    result = result.replace("'", '')
    return result

class ExprEval(ExprVisitor):

    def __init__(self):
        self.vars = {}
        self.varsClass = {}  # ID : Instancia classe

    def visitRoot(self, ctx: ExprParser.RootContext):
        fill = next(ctx.getChildren())
        return self.visit(fill)

    # Visit a parse tree produced by ExprParser#vertexdef.
    def visitVertexdef(self, ctx: ExprParser.VertexdefContext):
        fills = [i for i in ctx.getChildren()]
        x = float(fills[0].getText())
        y = float(fills[1].getText())
        return [x, y]

    # Visit a parse tree produced by ExprParser#listvertexs.
    def visitListvertexs(self, ctx: ExprParser.ListvertexsContext):
        vertexs = [i for i in ctx.getChildren()]
        vertexs.pop(0)  # em carrego el [
        vertexs.pop(-1)  # em carrego el ]
        poligon = []  # declaro llista buida
        for i in vertexs:
            poligon.append(self.visit(i))
        self.varsClass['last'] = poligon
        return poligon

        # Visit a parse tree produced by ExprParser#newpoly.

    def visitNewpoly(self, ctx: ExprParser.NewpolyContext):
        # creo llista amb tots els fills
        fills = [i for i in ctx.getChildren()]
        poligonID = fills[0].getText()
        vertex = self.visit(fills[2])
        self.vars[poligonID] = vertex
        if not isinstance(vertex, Polygons):
            self.varsClass[poligonID] = Polygons(vertex)
        else:
            self.varsClass[poligonID] = vertex
        return None

    # Visit a parse tree produced by ExprParser#assigncolor.
    def visitAssigncolor(self, ctx: ExprParser.AssigncolorContext):
        fills = [i for i in ctx.getChildren()]
        # agafo el poligon al que li asignare el color
        poligon = fills[1].getText()
        color = fills[3].getText()
        self.varsClass[poligon].set_color(color)
        return None



    # Visit a parse tree produced by ExprParser#operaciopoligonsimple.

    def visitOperaciopoligonsimple(self, ctx: ExprParser.OperaciopoligonsimpleContext):
        fills = [i for i in ctx.getChildren()]
        simbol = fills[0].getSymbol().type

        if simbol == ExprParser.PERIMETER:
            f1 = self.visit(fills[1])
            result = str(changeFormat(self.varsClass[f1].get_perimeter(), value=True))
            return result
        # casos:
            # p1 , p2
            # p1 + p2 , #p3
            # p1 , p2 + p3
        elif simbol == ExprParser.EQUAL:
            f1 = self.visit(fills[1])
            f2 = self.visit(fills[3])
            if isinstance(f1, list) and not isinstance(f2, Polygons):
                p1 = Polygons(f1)
                result = p1.equal(self.varsClass[f2].get_hull())
                return transbool(result)
            elif isinstance(f1, list) and isinstance(f2, list):
                p1 = Polygons(f1)
                p2 = Polygons(f2)
                result = p1.equal(p2.get_hull())
                return transbool(result)
            # cas un union ( retorna poigon) + un bounding (retorna list)
            elif isinstance(f1, Polygons) and isinstance(f2, list):
                result = f1.equal(f2)
                return transbool(result)

            # cas : els dos son strings i tenen instancies
            else:
                result = self.varsClass[f1].equal(self.varsClass[f2].get_hull())
                return transbool(result)

        elif simbol == ExprParser.INSIDE:
            f1 = self.visit(fills[1])
            f2 = self.visit(fills[3])
            if type(f1) == list:
                return transbool(self.varsClass[f2].inside(f1))
            else:
                return transbool(self.varsClass[f2].inside(self.varsClass[f1].get_hull()))

        elif simbol == ExprParser.AREA:
            f1 = self.visit(fills[1])
            return str(changeFormat(self.varsClass[f1].get_area(),value=True))

        elif simbol == ExprParser.PRINT:
            f1 = self.visit(fills[1])
            if not isinstance(f1, str) and not isinstance(f1, list):
                result = f1.get_hull()
                result = changeFormat(result)
                return replace(result)

            elif isinstance(f1, list):
                result = changeFormat(f1)
                return replace(result)

            elif isinstance(f1, Polygons):
                result = f1.get_hull()
                result = changeFormat(result)
                return replace(result)
            else:
                result = self.varsClass[f1].get_hull()
                result = changeFormat(result)
                return replace(result)

        elif simbol == ExprParser.CENTROID:
            f1 = self.visit(fills[1])
            result = str(self.varsClass[f1].centroid())
            return replace(result)

        elif simbol == ExprParser.VERTICES:
                f1 = self.visit(fills[1])
                return str(self.varsClass[f1].get_vertex())

        # definir
        elif simbol == ExprParser.DRAW:
            txt = fills[1].getText().replace('"', '')
            f2 = self.visit(fills[3])
            llista_poligons = [self.varsClass[f2]]
            for i in range(4, len(fills)):
                if fills[i].getText() != ',':
                    llista_poligons.append(self.varsClass[self.visit(fills[i])])
            result = draw(llista_poligons, name=txt)
            return result
    # Visit a parse tree produced by ExprParser#operadorspoligons.

    def visitOperadorspoligons(self, ctx: ExprParser.OperadorspoligonsContext):
        fills = [i for i in ctx.getChildren()]
        f1 = self.visit(fills[0])
        f2 = self.visit(fills[2])
        simbol = fills[1].getSymbol().type

        if simbol == ExprParser.UNION :
            result = self.varsClass[f1].union(self.varsClass[f2].get_points())

        elif simbol == ExprParser.INTERSECTION:
            result = self.varsClass[f1].interseccio(self.varsClass[f2])
        return Polygons(result)

    # Visit a parse tree produced by ExprParser#colorvalues.

    def visitColorvalues(self, ctx: ExprParser.ColorvaluesContext):
        values = [i for i in ctx.getChildren()]
        r = float(values[1].getText())
        g = float(values[2].getText())
        b = float(values[3].getText())
        return [r, g, b]

    # Visit a parse tree produced by ExprParser#poligonID.
    def visitPoligonID(self, ctx: ExprParser.PoligonIDContext):
        # asumirem que tots els inputs son valids i l'id sempre existeix
        fill = next(ctx.getChildren())
        return fill.getText()

        # Visit a parse tree produced by ExprParser#operadorspoligons2.

    def visitOperadorspoligons2(self, ctx: ExprParser.Operadorspoligons2Context):
        fills = [i for i in ctx.getChildren()]
        simbol = fills[0].getSymbol().type
        f1 = self.visit(fills[1])
        if simbol == ExprParser.BOUNDINGBOX:
            if isinstance(f1, str):
                result = self.varsClass[f1].bounding()
                return result
            elif isinstance(f1, Polygons):
                return f1.bounding()
            elif isinstance(f1, list):
                p1 = Polygons(f1)
                return p1.bounding()
        elif simbol == ExprParser.POLI:
            p1 = Polygons([])
            n = fills[1].getText()
            result = p1.generate_random_poligon(int(n))
            return result

    def visitPrinttxt(self, ctx:ExprParser.PrinttxtContext):
        fills = [i for i in ctx.getChildren()]
        result = fills[1].getText()
        result = result.replace('"' , '')
        return result