
extern "C" int main(int argc, char *argv[]) {
    char *loc = (char *) 0xB8000;

    loc[0] = 'H';
    loc[2] = 'i';

    return 0;
}
