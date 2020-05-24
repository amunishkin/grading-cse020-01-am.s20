import MathLib as math

"""
Testing platform part2 for MathLib module
"""

if __name__ == '__main__':
    math_obj1 = math.MyMathLib(25)

    print("Math obj1 value = ",math_obj1.get_curr_value() )

    math_obj1.add(-25)
    print("Math obj1 value = ",math_obj1.get_curr_value() )

    math_obj1.add(25)
    math_obj1.sqrt()
    assert (math_obj1.get_curr_value() == 5)
    print("Math obj1 value = ",math_obj1.get_curr_value() )

