import MathLib as math

"""
Testing platform part1 for MathLib module
"""

if __name__ == '__main__':
    math_obj1 = math.MyMathLib(2.0)
    math_obj2 = math.MyMathLib(-0.5)
    math_obj3 = math.MyMathLib() # this should give 0.0

    print("Math obj1 value = ",math_obj1.get_curr_value() )
    print("Math obj2 value = ",math_obj2.get_curr_value() )
    print("Math obj3 value = ",math_obj3.get_curr_value() )

