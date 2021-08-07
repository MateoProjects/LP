# Generated from Expr.g4 by ANTLR 4.7.2
from antlr4 import *
if __name__ is not None and "." in __name__:
    from .ExprParser import ExprParser
else:
    from ExprParser import ExprParser

# This class defines a complete generic visitor for a parse tree produced by ExprParser.

class ExprVisitor(ParseTreeVisitor):

    # Visit a parse tree produced by ExprParser#root.
    def visitRoot(self, ctx:ExprParser.RootContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ExprParser#expresiopoligon.
    def visitExpresiopoligon(self, ctx:ExprParser.ExpresiopoligonContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ExprParser#vertexdef.
    def visitVertexdef(self, ctx:ExprParser.VertexdefContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ExprParser#listvertexs.
    def visitListvertexs(self, ctx:ExprParser.ListvertexsContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ExprParser#newpoly.
    def visitNewpoly(self, ctx:ExprParser.NewpolyContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ExprParser#assigncolor.
    def visitAssigncolor(self, ctx:ExprParser.AssigncolorContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ExprParser#operaciopoligonsimple.
    def visitOperaciopoligonsimple(self, ctx:ExprParser.OperaciopoligonsimpleContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ExprParser#printtxt.
    def visitPrinttxt(self, ctx:ExprParser.PrinttxtContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ExprParser#operadorspoligons.
    def visitOperadorspoligons(self, ctx:ExprParser.OperadorspoligonsContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ExprParser#operadorspoligons2.
    def visitOperadorspoligons2(self, ctx:ExprParser.Operadorspoligons2Context):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ExprParser#colorvalues.
    def visitColorvalues(self, ctx:ExprParser.ColorvaluesContext):
        return self.visitChildren(ctx)


    # Visit a parse tree produced by ExprParser#poligonID.
    def visitPoligonID(self, ctx:ExprParser.PoligonIDContext):
        return self.visitChildren(ctx)



del ExprParser