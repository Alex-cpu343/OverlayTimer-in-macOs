
#include <mach/mach_time.h>

class MyClock{
private:
    uint64_t m_start;
    double m_ticks;
public:
    MyClock(){
        mach_timebase_info_data_t info;// info.numer and info.demon
        mach_timebase_info(&info);
        m_ticks = (double)info.numer / info.denom;// скільки наносекунд в одному тіку
        m_start = mach_absolute_time();
    };
    double elapsedSeconds(){
        uint64_t now = mach_absolute_time();// поточний час
        return (now - m_start)*m_ticks /1e9;// time
        
    };
    void reset(){
        m_start =mach_absolute_time();

    };
    
};
