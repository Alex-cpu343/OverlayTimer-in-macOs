#pragma once
#include "MyClock.cpp"


class Timer{
    
private:
    MyClock m_clock;
    int second;
    bool running;
public:
    Timer(){
        second = 0;
        running = false;
    }
    void start(){
        running = true;
        m_clock.reset();
        
    }
    void stop(){
        running = false;
        
    }
    void reset(){
        running = false;
        second = 0;
        m_clock.reset();
    }
    void tick() {
        if (running){
            if (m_clock.elapsedSeconds() >= 1.0) {
                second++;          // +1 секунда
                m_clock.reset();   // скидаємо годинник
            }
        }
    }
    
    int getHour(){
        return (second)/3600; // година
    }
    int getMinut(){
        return (second/60)%60; // хвилина
    }
    int getSecond(){
        return (second)%60;// секунда
    }
    bool isRunning(){
        return running;// повернення чи запустоловся таймер
    }
};
