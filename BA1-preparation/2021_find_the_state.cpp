#include <iostream>
#include <string>

int main()
{
    std::string input;
    std::cin >> input;

    int state = 1;
    for (char c : input)
    {
        switch (state)
        {
        case 1:
            if (c == 'a')
                state = 2;
            else if (c == 'b')
                state = 3;
            break;
        case 2:
            if (c == 'a')
                state = 2;
            else if (c == 'b')
                state = 4;
            break;
        case 3:
            if (c == 'a')
                state = 3;
            break;
        case 4:
            if (c == 'c')
                state = 4;
            break;
        default:
            break;
        }
    }

    if (state == 4 || state == 3)
    {
        std::cout << "YES s" << state;
    }
    else
    {
        std::cout << "NO";
    }

    return 0;
}
