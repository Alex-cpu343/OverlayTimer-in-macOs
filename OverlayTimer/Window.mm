#include "Timer.h"
#include "Clock.cpp"
#import <Cocoa/Cocoa.h>

@interface OverlayWindow : NSPanel {
    NSTextField* clockLabel;
    NSTextField* timerLabel;
    NSTextField* clockTitle;
    NSTextField* timerTitle;
    NSButton*    startBtn;
    NSButton*    resetBtn;
    NSButton*    closeBtn;
    Timer        timer;
    Clock        clock;
}
- (void)update;
- (void)startStop;
- (void)resetTimer;
- (void)closeApp;
@end

@implementation OverlayWindow
- (BOOL)canBecomeKeyWindow {
    return YES;
}
- (NSMutableAttributedString*)whiteText:(NSString*)text size:(CGFloat)size {
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName
                value:[NSColor whiteColor]
                range:NSMakeRange(0, text.length)];
    [str addAttribute:NSFontAttributeName
                value:[NSFont systemFontOfSize:size weight:NSFontWeightRegular]
                range:NSMakeRange(0, text.length)];
    return str;
}

- (instancetype)init {
    self = [super initWithContentRect:NSMakeRect(100, 100, 520, 60)
                            styleMask:NSWindowStyleMaskNonactivatingPanel |
                                      NSWindowStyleMaskFullSizeContentView
                              backing:NSBackingStoreBuffered
                                defer:NO];
    if (self) {
        [self setLevel:NSScreenSaverWindowLevel];
        [self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces |
                                    NSWindowCollectionBehaviorStationary |
                                    NSWindowCollectionBehaviorFullScreenAuxiliary];
        [self setOpaque:NO];
        [self setMovableByWindowBackground:YES];
        [self setBackgroundColor:[NSColor clearColor]];
        [self setHasShadow:YES];

        // фон
        NSView* bg = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 520, 60)];
        bg.wantsLayer = YES;
        bg.layer.backgroundColor = [NSColor colorWithRed:0.08
                                                    green:0.08
                                                     blue:0.10
                                                    alpha:0.95].CGColor;
        bg.layer.cornerRadius = 14;
        [[self contentView] addSubview:bg];

        // ---- ГОДИННИК ----
        clockTitle = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 38, 160, 14)];
        [clockTitle setStringValue:@"CLOCK"];
        [clockTitle setBezeled:NO];
        [clockTitle setDrawsBackground:NO];
        [clockTitle setEditable:NO];
        [clockTitle setSelectable:NO];
        [clockTitle setTextColor:[NSColor colorWithWhite:0.5 alpha:1.0]];
        [clockTitle setFont:[NSFont systemFontOfSize:9 weight:NSFontWeightSemibold]];
        [[self contentView] addSubview:clockTitle];

        clockLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(16, 12, 180, 28)];
        [clockLabel setStringValue:@"00:00:00"];
        [clockLabel setBezeled:NO];
        [clockLabel setDrawsBackground:NO];
        [clockLabel setEditable:NO];
        [clockLabel setSelectable:NO];
        [clockLabel setTextColor:[NSColor whiteColor]];
        [clockLabel setFont:[NSFont monospacedDigitSystemFontOfSize:20
                                                             weight:NSFontWeightLight]];
        [[self contentView] addSubview:clockLabel];

        // розділювач
        NSView* divider = [[NSView alloc] initWithFrame:NSMakeRect(210, 10, 1, 40)];
        divider.wantsLayer = YES;
        divider.layer.backgroundColor = [NSColor colorWithWhite:0.25 alpha:1.0].CGColor;
        [[self contentView] addSubview:divider];

        // ---- ТАЙМЕР ----
        timerTitle = [[NSTextField alloc] initWithFrame:NSMakeRect(226, 38, 160, 14)];
        [timerTitle setStringValue:@"TIMER"];
        [timerTitle setBezeled:NO];
        [timerTitle setDrawsBackground:NO];
        [timerTitle setEditable:NO];
        [timerTitle setSelectable:NO];
        [timerTitle setTextColor:[NSColor colorWithWhite:0.5 alpha:1.0]];
        [timerTitle setFont:[NSFont systemFontOfSize:9 weight:NSFontWeightSemibold]];
        [[self contentView] addSubview:timerTitle];

        timerLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(222, 12, 180, 28)];
        [timerLabel setStringValue:@"00:00:00"];
        [timerLabel setBezeled:NO];
        [timerLabel setDrawsBackground:NO];
        [timerLabel setEditable:NO];
        [timerLabel setSelectable:NO];
        [timerLabel setTextColor:[NSColor whiteColor]];
        [timerLabel setFont:[NSFont monospacedDigitSystemFontOfSize:20
                                                             weight:NSFontWeightLight]];
        [[self contentView] addSubview:timerLabel];

        // ---- КНОПКИ ----
        startBtn = [[NSButton alloc] initWithFrame:NSMakeRect(414, 17, 36, 26)];
        [startBtn setAttributedTitle:[self whiteText:@"▶" size:14]];
        [startBtn setBezelStyle:NSBezelStyleRounded];
        [startBtn setTarget:self];
        [startBtn setAction:@selector(startStop)];
        [[self contentView] addSubview:startBtn];

        resetBtn = [[NSButton alloc] initWithFrame:NSMakeRect(453, 17, 28, 26)];
        [resetBtn setAttributedTitle:[self whiteText:@"↺" size:14]];
        [resetBtn setBezelStyle:NSBezelStyleRounded];
        [resetBtn setTarget:self];
        [resetBtn setAction:@selector(resetTimer)];
        [[self contentView] addSubview:resetBtn];

        closeBtn = [[NSButton alloc] initWithFrame:NSMakeRect(484, 17, 28, 26)];
        [closeBtn setAttributedTitle:[self whiteText:@"✕" size:14]];
        [closeBtn setBezelStyle:NSBezelStyleRounded];
        [closeBtn setTarget:self];
        [closeBtn setAction:@selector(closeApp)];
        [[self contentView] addSubview:closeBtn];

        // оновлення кожні 0.1 сек
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(update)
                                       userInfo:nil
                                        repeats:YES];
    }
    return self;
}

- (void)update {
    timer.tick();

    NSString* clockStr = [NSString stringWithFormat:@"%02d:%02d:%02d",
                          clock.getHour(),
                          clock.getMinut(),
                          clock.getSecond()];
    [clockLabel setStringValue:clockStr];

    NSString* timerStr = [NSString stringWithFormat:@"%02d:%02d:%02d",
                          timer.getHour(),
                          timer.getMinut(),
                          timer.getSecond()];
    [timerLabel setStringValue:timerStr];
}

- (void)startStop {
    if (timer.isRunning()) {
        timer.stop();
        [startBtn setAttributedTitle:[self whiteText:@"▶" size:14]];
    } else {
        timer.start();
        [startBtn setAttributedTitle:[self whiteText:@"⏸" size:14]];
    }
}

- (void)resetTimer {
    timer.reset();
    [startBtn setAttributedTitle:[self whiteText:@"▶" size:14]];
}

- (void)closeApp {
    [NSApp terminate:nil];
}

@end

extern "C" void startApp() {
    [NSApplication sharedApplication];
    OverlayWindow* window = [[OverlayWindow alloc] init];
    [window makeKeyAndOrderFront:nil];
    [NSApp run];
}
