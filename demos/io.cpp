// Blocking I/O example

#include <iostream>
using namespace std;

int main(){
    string name;

    cout << "Type your name: ";
    getline(cin, name);

    cout << "Entered: " << name << endl;

    return 0;
}
