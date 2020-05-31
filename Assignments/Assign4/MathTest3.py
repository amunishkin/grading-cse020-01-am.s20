import MathLib as math

"""
Testing platform part3 for MathLib module
"""

if __name__ == '__main__':
    math_obj1 = math.MyMathLib(0.0)
    math_obj2 = math.MyMathLib(75.0)

    math_obj1.add(14)
    math_obj1.mult(1)
    print("Math obj1 value = ",math_obj1.get_curr_value() )

    math_obj2.divid(3)
    math_obj2.sqrt()
    math_obj1.add(math_obj2.get_curr_value())
    print("Math obj1 value = ",math_obj1.get_curr_value() )
    print("Math obj2 value = ",math_obj2.get_curr_value() )
    assert (math_obj2.get_curr_value() == 5)

    numbers = [1,5,6,7,10]
    math_obj1.sequence_sum(numbers)
    math_obj1.mult(12)
    print("Math obj1 value = ",math_obj1.get_curr_value() )
