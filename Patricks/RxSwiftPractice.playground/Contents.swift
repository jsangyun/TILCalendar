import Foundation

func fact(_ x: Int) -> Int {
    var temp: Int
    temp = x;
    if(temp == 0) {
        return 1;
    } else {
        temp = temp * fact(temp-1);
    }
    return temp;
}

print(fact(5))
