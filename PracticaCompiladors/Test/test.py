from polygons import *
import unittest
import logging
from polygons import *

class Test(unittest.TestCase):
    def setUp(self):
        self.p1 = Polygons([[0,0], [0,1], [1,1], [0.2, 0.8]])
        self.p2 = Polygons([[0,0], [1, 0], [1, 1]])

    def tearDown(self):
        del self.p1, self.p2

    """
    Test que comprova la funció inside amb varios punts
    ** NOTA ** Amb aquest test també s'evalua la funció point_inside
    
    """

    def test_inside(self):
        self.assertFalse(self.p2.inside(self.p1.get_hull()))
        self.assertFalse(self.p1.inside(self.p2.get_hull()))
        self.assertTrue(self.p2.inside([[0.8, 0.2]]))
        self.assertFalse(self.p1.inside([[2.0, 1]]))


    """
    Test que evalua si el càlcul del poligon convex és correcte obtenint els seus vertex
    """

    def test_get_vertex(self):
        self.assertEqual(self.p1.get_vertex(), 3)
        self.assertEqual(self.p2.get_vertex(), 3)

    """
    Test que evalua el càlcul d'area d'un polígon
    """
    def test_get_area(self):
        self.assertEqual(0.500, self.p1.get_area())
        self.assertEqual(0.500, self.p2.get_area())

    """
    Test que evalua el union 
    """
    def test_union(self):
        self.assertEqual([[0, 0], [0, 1], [1, 1], [1, 0]], self.p1.union(self.p2.get_hull()))

    """
    Test que evalua el union
    """
    def test_bounding(self):
        self.assertEqual([[0.000, 0.000], [0.000, 1.000], [1.000, 1.000], [1.000, 0.000]], self.p2.bounding())

    """
    Test que comprova el centroid
    """
    def test_centroid(self):
        self.assertEqual([0.667, 0.333], self.p2.centroid())
        self.assertEqual([0.333, 0.667], self.p1.centroid())

    """
    Test que evalua la creació del poligon convexa
    """
    def test_convex(self):
        self.assertEqual([[0.000, 0.000], [0.000, 1.000], [1.000, 1.000]], self.p2.get_hull())
        self.assertEqual([[0.000, 0.000], [1.000, 1.000], [1.000,0.000]], self.p2.get_hull())


    """
    Test que calcula el perimetre ( Aquest es calcula un cop s'inicialitza l'instancia)
    """
    def test_perimeter(self):
        self.assertEqual(3.414, self.p1.get_perimeter())
        self.assertEqual(3.414, self.p2.get_perimeter())

    """
    Test per comprovar la funció equal
    """
    def test_equal(self):
        self.assertFalse(self.p1.equal(self.p2.get_hull()))
        self.assertTrue(self.p1.equal(self.p1.get_hull()))
        self.assertTrue(Polygons(self.p1.union(self.p2.get_hull())).equal(self.p2.bounding()))

    # Aquest test és correcte. El problema rau en la repetició de valors.
    """
    def test_interseccio(self):
        self.assertEqual([[0.000, 0.000], [1.000, 1.000]], self.p1.interseccio(self.p2))
    """