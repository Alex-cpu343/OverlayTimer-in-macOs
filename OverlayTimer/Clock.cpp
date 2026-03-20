#include <ctime>
class Clock{

public:
    int getHour(){
        time_t now = time(nullptr); // просто поточний час
        return localtime(&now)->tm_hour;// звертання до години
        
    }
    int getMinut(){
        time_t now = time(nullptr);
        return localtime(&now)->tm_min;// звертання до хвилинни
    }
    int getSecond(){
        time_t now = time(nullptr);
        return localtime(&now)->tm_sec;// звертання до секунди
    }
};

