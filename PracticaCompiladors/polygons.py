import functools
import math
import os
from random import random
from PIL import Image, ImageDraw, ImagePath

INT_MAX = 10000


def translacio(poligon):
    x = poligon[0][0]
    y = poligon[0][1]
    trans = poligon
    for i in range(len(poligon)):
        trans[i][0] = poligon[i][0] - x
        trans[i][1] = poligon[i][1] - y
    return trans

def get_list_format(list):
    pl = []
    lp = list.get_hull()
    for i in range(len(lp)):
        pl.append((lp[i][0], lp[i][1]))
    return pl

def transColor(color):
    return (int(int(color[0])*255), int(int(color[1])*255), int(int(color[2])*255))


def getIntersectionPoint(p1x1, p1y1, p1x2, p1y2 , p2x1 , p2y1 , p2x2 , p2y2):
    A1 = float(p1y2 - p1y1)
    B1 = float(p1x1 - p1x2)
    C1 = float(A1 * p1x1 + B1 * p1y1)
    A2 = float(p2y2 - p2y1)
    B2 = float(p2x1 - p2x2)
    C2 = float(A2 * p2x1 + B1 * p2y1)
    det = float(A1 * B2 - A2 * B1)
    if det == 0:
        #lineas paralelas
        return None

    else:
        x = (B2 * C1 - B1 * C2) / det
        y = (A1 * C2 - A2 * C1) / det

        online1 = ((min(p1x1, p1x2) < x or min(p1x1, p1x2) == x)
                   and (max(p1x1, p1x2) > x or max(p1x1, p1x2) == x)
                   and (min(p1y1, p1y2) < y or min(p1y1, p1y2) == y)
                   and (max(p1y1, p1y2) > y or max(p1y1, p1y2) == y))

        online2 = ((min(p2x1, p2x2) < x or min(p2x1, p2x2) == x)
                   and (max(p2x1, p2x2) > x or max(p2x1, p2x2) == x)
                   and (min(p2y1, p2y2) < y or min(p2y1, p2y2) == y)
                   and (max(p2y1, p2y2) > y or max(p2y1, p2y2) == y))

        if online1 == online2:
            if x == float(-0) or x == float(+0):
                x = float(0)
            if y == float(-0) or y == float(+0):
                y = float(0)
            return [float(x), float(y)]
        else:
            return None


def getIntersectionPoints(p1x1, p1y1, p1x2, p1y2,  poligon):
    intersectionPoints = []
    long = len(poligon.get_hull())
    pol = poligon.get_hull()
    for i in range(long):

        if (i +1) == long:
            next = 0
        else :
            next = i + 1
        ip = getIntersectionPoint(p1x1, p1y1, p1x2, p1y2, pol[0][0], pol[0][1], pol[next][0], pol[next][1])

        if ip != None:
            intersectionPoints.append(ip)

    return intersectionPoints

# Es defineix fora . Aquesta funcio podria rebre un self o una llista. Asumirem que sempre rebra un list
def draw(points, color=(255, 255, 255) , name= "poligon.png"):
    # tinc la llista de punts i calculu la seva caixa novament
    top_right_x = -3000
    top_right_y = -3000
    bot_left_x = 3000
    bot_left_y = 3000
    for p in points:
        list_of_points = p.get_hull()
        blx = min(point[0] for point in list_of_points)
        bly = min(point[1] for point in list_of_points)
        trx = max(point[0] for point in list_of_points)
        trhy = max(point[1] for point in list_of_points)
        if top_right_x < trx:
            top_right_x = trx
        if top_right_y < trhy:
            top_right_y = trhy
        if bot_left_x > blx:
            bot_left_x = blx
        if bot_left_y > bly:
            bot_left_y = bly

    sizeX = top_right_x - bot_left_x
    sizeY = top_right_y - bot_left_y
    scaleX = 396 / sizeX
    scaleY = 396 / sizeY
    incX = bot_left_x * (-1)
    incY = bot_left_y * (-1)
    list_aux = points
    # escalat
    for i in range(len(list_aux)):
        list_points = list_aux[i].get_hull()
        for j in range(len(list_points)):
            list_points[j][0] = list_points[j][0] * scaleX
            list_points[j][1] = list_points[j][1] * scaleY
        list_aux[i].set_points(list_points)

    #translacio
    for i in range(len(list_aux)):
        list_points = list_aux[i].get_hull()
        for j in range(len(list_points)):
            list_points[j][0] = list_points[j][0] + incX
            list_points[j][1] = list_points[j][1] + incY
        list_aux[i].set_points(list_points)

    # tinc ja el points escalat i posicionat
    # el color em vindra aixi ('0', '1', '0')
    img = Image.new("RGB", size=(400, 400), color=color)
    printI = ImageDraw.Draw(img)
    for p in list_aux:
        colorp = transColor(p.get_color())
        coordAUX = get_list_format(p)
        if p.get_vertex() >= 2:
            printI.polygon(coordAUX, outline=colorp)
        else:
            printI.point(coordAUX, fill=colorp)


    fm = img.rotate(90)
    fm.save(name)
    return os.path.abspath(name)


class Polygons:

    def __init__(self, list_points):
        self.hull = None
        if type(list_points) == list and len(list_points) > 0:
            self.points = list_points
            self.hull = self._convex_hull_graham()
            self.perimeter = self.calculperimeter()
        self.areahull = None
        self.color = None



    """
    Function that returns if poligon is inside other poligon
    """

    def inside(self, poligon):
        inside = True
        for i in poligon:
            if not self.point_inside(i[0], i[1], self.hull):
                inside = False
        return inside



    def point_inside(self, x, y, poligon):
        list_points = poligon
        i = 0
        j = len(list_points) - 1
        salida = False
        for i in range(len(list_points)):
            if (list_points[i][1] < y and list_points[j][1] >= y) or (list_points[j][1] < y and list_points[i][1] >= y):
                if list_points[i][0] + (y - list_points[i][1]) / (list_points[j][1] - list_points[i][1]) * (
                        list_points[j][0] - list_points[i][0]) < x:
                    salida = not salida
            j = i
        return salida


    def get_vertex(self):
        return len(self.hull)

    def get_area(self):
        nvertexs = len(self.hull)
        x = []
        y = []
        for i in range(len(self.hull)):
            x.append(float(self.hull[i][0]))
            y.append(float(self.hull[i][1]))

        return abs(self.calcularea(x, y, nvertexs))

    def calcularea(self, x, y, n):
        suma = x[0] * y[n - 1] - x[n - 1] * y[0]

        for i in range(n - 1):
            suma += x[i + 1] * y[i] - x[i] * y[i + 1]

        self.areahull = round(suma / 2, 3)
        return round(suma / 2, 3)

    def get_points(self):
        return self.points


    def union(self, poligon):
        union = self.points + poligon
        return self._convex_hull_graham(union, union=True)

    def bounding(self):
        points = self.hull
        bot_left_x = min(point[0] for point in points)
        bot_left_y = min(point[1] for point in points)
        top_right_x = max(point[0] for point in points)
        top_right_y = max(point[1] for point in points)
        return [[bot_left_x, bot_left_y], [bot_left_x, top_right_y], [top_right_x, top_right_y], [top_right_x, bot_left_y]]

    def centroid(self):
        vertexes = self.get_hull()
        _x_list = [vertex[0] for vertex in vertexes]
        _y_list = [vertex[1] for vertex in vertexes]
        _len = len(vertexes)
        _x = sum(_x_list) / _len
        _y = sum(_y_list) / _len
        return ["{:.3f}".format(_x), "{:.3f}".format(_y)]


    def _convex_hull_graham(self, points_union=None, union=False):

        def cmp(a, b):
            return (a > b) - (a < b)

        def turn(p, q, r):
            return cmp((q[0] - p[0]) * (r[1] - p[1]) - (r[0] - p[0]) * (q[1] - p[1]), 0)

        def _keep_left(hull, r):
            while len(hull) > 1 and turn(hull[-2], hull[-1], r) != -1:
                hull.pop()
            if not len(hull) or hull[-1] != r:
                hull.append(r)
            return hull
        if not union:
            points = sorted(self.points)
        else:
            points = sorted(points_union)
        l = functools.reduce(_keep_left, points, [])
        u = functools.reduce(_keep_left, reversed(points), [])
        return l.extend(u[i] for i in range(1, len(u) - 1)) or l

    def get_hull(self):
        return self.hull

    def set_color(self, color):
        color = str(color).replace('{', '')
        color = color.replace('}', '')
        self.color = (color[0], color[1], color[2])

    def calculperimeter(self):
        distance = 0
        p = self.hull
        for i in range(len(self.hull) - 1):
            distance += math.sqrt(((p[i][0] - p[i + 1][0]) ** 2) + ((p[i][1] - p[i + 1][1]) ** 2))
        distance += math.sqrt(((p[0][0] - p[len(self.hull) - 1][0]) ** 2) + ((p[0][1] - p[len(self.hull) - 1][1]) ** 2))
        return round(distance, 3)

    def get_perimeter(self):
        return self.perimeter

    def equal(self, poligon):
        p_hull = translacio(self.hull)
        p_poligon = translacio(poligon)
        if len(poligon) != len(self.hull):
            return False
        for i in range (len(poligon)):
            if p_poligon[i][0] != p_hull[i][0] or \
                    p_poligon[i][1] != p_hull[i][1]:
                return False
        return True

    def generate_random_poligon(self , n):
        rd = []
        for i in range(0, n):
            rd.append([random(), random()])
        print(rd)
        self.points = rd
        return self._convex_hull_graham()

    def interseccio(self, p2):
        # code obtained and translated to python : https: // www.swtestacademy.com / intersection - convex - polygons - algorithm /
        if self.inside(p2.get_hull()):
            return self.get_hull()
        elif p2.inside(self.get_hull()):
            return p2.get_hull()

        list_p1 = self.get_hull()
        list_p2 = p2.get_hull()
        list_of_points = []
        length_p1 = len(list_p1)
        length_p2 = len(list_p2)
        for i in range(length_p1):
            if self.point_inside(list_p1[i][0], list_p1[i][1], list_p2):
                list_of_points.append([list_p1[i][0], list_p1[i][1]])

        for i in range(length_p2):
            if self.point_inside(list_p2[i][0], list_p2[i][1], list_p1):
                list_of_points.append([list_p2[i][0], list_p2[i][1]])
        next = 1
        for i in range(length_p1):

            list_of_points = list_of_points + (getIntersectionPoints(list_p1[i][0], list_p1[i][1], list_p1[next][0], list_p1[next][1], p2))
            if (i + 1) == length_p1:
                next = 0
            else :
                next = i + 1
        return list_of_points

    def set_points(self, hull):
        self.hull = hull

    def get_color(self):
        return self.color
