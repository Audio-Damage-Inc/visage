/* Copyright Vital Audio, LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

#if VISAGE_IOS
#include "windowing_ios.h"

#include "visage_utils/time_utils.h"

namespace visage {
  class InitialMetalLayer {
  public:
    static CAMetalLayer* layer() { return instance().metal_layer_; }

  private:
    static InitialMetalLayer& instance() {
      static InitialMetalLayer instance;
      return instance;
    }

    InitialMetalLayer() {
      metal_layer_ = [CAMetalLayer layer];
      metal_layer_.device = MTLCreateSystemDefaultDevice();
      metal_layer_.colorspace = CGColorSpaceCreateWithName(kCGColorSpaceDisplayP3);
    }

    CAMetalLayer* metal_layer_ = nullptr;
  };

  // Set by WindowIos::runEventLoop before UIApplicationMain, read back by the
  // app delegate once UIKit is up. Standalone is single-window by definition,
  // so a single pointer is enough.
  WindowIos* standalone_window = nullptr;

  // UIKey.keyCode is a USB HID usage: the physical key, as a macOS virtual key
  // code is -- so this maps the same keys the macOS backend's translateKeyCode
  // does, and a layout behaves the same way on both.
  API_AVAILABLE(ios(13.4))
  KeyCode translateKeyCode(UIKeyboardHIDUsage usage) {
    switch (usage) {
    case UIKeyboardHIDUsageKeyboardA: return KeyCode::A;
    case UIKeyboardHIDUsageKeyboardB: return KeyCode::B;
    case UIKeyboardHIDUsageKeyboardC: return KeyCode::C;
    case UIKeyboardHIDUsageKeyboardD: return KeyCode::D;
    case UIKeyboardHIDUsageKeyboardE: return KeyCode::E;
    case UIKeyboardHIDUsageKeyboardF: return KeyCode::F;
    case UIKeyboardHIDUsageKeyboardG: return KeyCode::G;
    case UIKeyboardHIDUsageKeyboardH: return KeyCode::H;
    case UIKeyboardHIDUsageKeyboardI: return KeyCode::I;
    case UIKeyboardHIDUsageKeyboardJ: return KeyCode::J;
    case UIKeyboardHIDUsageKeyboardK: return KeyCode::K;
    case UIKeyboardHIDUsageKeyboardL: return KeyCode::L;
    case UIKeyboardHIDUsageKeyboardM: return KeyCode::M;
    case UIKeyboardHIDUsageKeyboardN: return KeyCode::N;
    case UIKeyboardHIDUsageKeyboardO: return KeyCode::O;
    case UIKeyboardHIDUsageKeyboardP: return KeyCode::P;
    case UIKeyboardHIDUsageKeyboardQ: return KeyCode::Q;
    case UIKeyboardHIDUsageKeyboardR: return KeyCode::R;
    case UIKeyboardHIDUsageKeyboardS: return KeyCode::S;
    case UIKeyboardHIDUsageKeyboardT: return KeyCode::T;
    case UIKeyboardHIDUsageKeyboardU: return KeyCode::U;
    case UIKeyboardHIDUsageKeyboardV: return KeyCode::V;
    case UIKeyboardHIDUsageKeyboardW: return KeyCode::W;
    case UIKeyboardHIDUsageKeyboardX: return KeyCode::X;
    case UIKeyboardHIDUsageKeyboardY: return KeyCode::Y;
    case UIKeyboardHIDUsageKeyboardZ: return KeyCode::Z;
    case UIKeyboardHIDUsageKeyboard1: return KeyCode::Number1;
    case UIKeyboardHIDUsageKeyboard2: return KeyCode::Number2;
    case UIKeyboardHIDUsageKeyboard3: return KeyCode::Number3;
    case UIKeyboardHIDUsageKeyboard4: return KeyCode::Number4;
    case UIKeyboardHIDUsageKeyboard5: return KeyCode::Number5;
    case UIKeyboardHIDUsageKeyboard6: return KeyCode::Number6;
    case UIKeyboardHIDUsageKeyboard7: return KeyCode::Number7;
    case UIKeyboardHIDUsageKeyboard8: return KeyCode::Number8;
    case UIKeyboardHIDUsageKeyboard9: return KeyCode::Number9;
    case UIKeyboardHIDUsageKeyboard0: return KeyCode::Number0;
    case UIKeyboardHIDUsageKeyboardReturnOrEnter: return KeyCode::Return;
    case UIKeyboardHIDUsageKeyboardEscape: return KeyCode::Escape;
    case UIKeyboardHIDUsageKeyboardDeleteOrBackspace: return KeyCode::Backspace;
    case UIKeyboardHIDUsageKeyboardTab: return KeyCode::Tab;
    case UIKeyboardHIDUsageKeyboardSpacebar: return KeyCode::Space;
    case UIKeyboardHIDUsageKeyboardHyphen: return KeyCode::Minus;
    case UIKeyboardHIDUsageKeyboardEqualSign: return KeyCode::Equals;
    case UIKeyboardHIDUsageKeyboardOpenBracket: return KeyCode::LeftBracket;
    case UIKeyboardHIDUsageKeyboardCloseBracket: return KeyCode::RightBracket;
    case UIKeyboardHIDUsageKeyboardBackslash: return KeyCode::Backslash;
    case UIKeyboardHIDUsageKeyboardSemicolon: return KeyCode::Semicolon;
    case UIKeyboardHIDUsageKeyboardQuote: return KeyCode::Apostrophe;
    case UIKeyboardHIDUsageKeyboardGraveAccentAndTilde: return KeyCode::Grave;
    case UIKeyboardHIDUsageKeyboardComma: return KeyCode::Comma;
    case UIKeyboardHIDUsageKeyboardPeriod: return KeyCode::Period;
    case UIKeyboardHIDUsageKeyboardSlash: return KeyCode::Slash;
    case UIKeyboardHIDUsageKeyboardCapsLock: return KeyCode::CapsLock;
    case UIKeyboardHIDUsageKeyboardF1: return KeyCode::F1;
    case UIKeyboardHIDUsageKeyboardF2: return KeyCode::F2;
    case UIKeyboardHIDUsageKeyboardF3: return KeyCode::F3;
    case UIKeyboardHIDUsageKeyboardF4: return KeyCode::F4;
    case UIKeyboardHIDUsageKeyboardF5: return KeyCode::F5;
    case UIKeyboardHIDUsageKeyboardF6: return KeyCode::F6;
    case UIKeyboardHIDUsageKeyboardF7: return KeyCode::F7;
    case UIKeyboardHIDUsageKeyboardF8: return KeyCode::F8;
    case UIKeyboardHIDUsageKeyboardF9: return KeyCode::F9;
    case UIKeyboardHIDUsageKeyboardF10: return KeyCode::F10;
    case UIKeyboardHIDUsageKeyboardF11: return KeyCode::F11;
    case UIKeyboardHIDUsageKeyboardF12: return KeyCode::F12;
    case UIKeyboardHIDUsageKeyboardF13: return KeyCode::F13;
    case UIKeyboardHIDUsageKeyboardF14: return KeyCode::F14;
    case UIKeyboardHIDUsageKeyboardF15: return KeyCode::F15;
    case UIKeyboardHIDUsageKeyboardF16: return KeyCode::F16;
    case UIKeyboardHIDUsageKeyboardF17: return KeyCode::F17;
    case UIKeyboardHIDUsageKeyboardF18: return KeyCode::F18;
    case UIKeyboardHIDUsageKeyboardF19: return KeyCode::F19;
    case UIKeyboardHIDUsageKeyboardF20: return KeyCode::F20;
    case UIKeyboardHIDUsageKeyboardHelp: return KeyCode::Help;
    case UIKeyboardHIDUsageKeyboardHome: return KeyCode::Home;
    case UIKeyboardHIDUsageKeyboardPageUp: return KeyCode::PageUp;
    case UIKeyboardHIDUsageKeyboardDeleteForward: return KeyCode::Delete;
    case UIKeyboardHIDUsageKeyboardEnd: return KeyCode::End;
    case UIKeyboardHIDUsageKeyboardPageDown: return KeyCode::PageDown;
    case UIKeyboardHIDUsageKeyboardLeftArrow: return KeyCode::Left;
    case UIKeyboardHIDUsageKeyboardRightArrow: return KeyCode::Right;
    case UIKeyboardHIDUsageKeyboardDownArrow: return KeyCode::Down;
    case UIKeyboardHIDUsageKeyboardUpArrow: return KeyCode::Up;
    case UIKeyboardHIDUsageKeypadPeriod: return KeyCode::KPDecimal;
    case UIKeyboardHIDUsageKeypadAsterisk: return KeyCode::KPMultiply;
    case UIKeyboardHIDUsageKeypadPlus: return KeyCode::KPPlus;
    case UIKeyboardHIDUsageKeypadNumLock: return KeyCode::KPClear;
    case UIKeyboardHIDUsageKeypadSlash: return KeyCode::KPDivide;
    case UIKeyboardHIDUsageKeypadEnter: return KeyCode::KPEnter;
    case UIKeyboardHIDUsageKeypadHyphen: return KeyCode::KPMinus;
    case UIKeyboardHIDUsageKeypadEqualSign: return KeyCode::KPEquals;
    case UIKeyboardHIDUsageKeypad0: return KeyCode::KP0;
    case UIKeyboardHIDUsageKeypad1: return KeyCode::KP1;
    case UIKeyboardHIDUsageKeypad2: return KeyCode::KP2;
    case UIKeyboardHIDUsageKeypad3: return KeyCode::KP3;
    case UIKeyboardHIDUsageKeypad4: return KeyCode::KP4;
    case UIKeyboardHIDUsageKeypad5: return KeyCode::KP5;
    case UIKeyboardHIDUsageKeypad6: return KeyCode::KP6;
    case UIKeyboardHIDUsageKeypad7: return KeyCode::KP7;
    case UIKeyboardHIDUsageKeypad8: return KeyCode::KP8;
    case UIKeyboardHIDUsageKeypad9: return KeyCode::KP9;
    case UIKeyboardHIDUsageKeyboardLeftGUI: return KeyCode::LGui;
    case UIKeyboardHIDUsageKeyboardLeftShift: return KeyCode::LShift;
    case UIKeyboardHIDUsageKeyboardLeftAlt: return KeyCode::LAlt;
    case UIKeyboardHIDUsageKeyboardLeftControl: return KeyCode::LCtrl;
    case UIKeyboardHIDUsageKeyboardRightGUI: return KeyCode::RGui;
    case UIKeyboardHIDUsageKeyboardRightShift: return KeyCode::RShift;
    case UIKeyboardHIDUsageKeyboardRightAlt: return KeyCode::RAlt;
    case UIKeyboardHIDUsageKeyboardRightControl: return KeyCode::RCtrl;
    case UIKeyboardHIDUsageKeyboardVolumeUp: return KeyCode::VolumeUp;
    case UIKeyboardHIDUsageKeyboardVolumeDown: return KeyCode::VolumeDown;
    case UIKeyboardHIDUsageKeyboardMute: return KeyCode::Mute;
    default: return KeyCode::Unknown;
    }
  }

  // The same modifier mapping the macOS backend makes.
  API_AVAILABLE(ios(13.4))
  int keyboardModifiers(UIKeyModifierFlags flags) {
    int result = 0;
    if (flags & UIKeyModifierCommand)
      result = result | kModifierCmd;
    if (flags & UIKeyModifierControl)
      result = result | kModifierMacCtrl;
    if (flags & UIKeyModifierAlternate)
      result = result | kModifierOption;
    if (flags & UIKeyModifierShift)
      result = result | kModifierShift;
    return result;
  }

  // Whether a key's characters are text to type rather than a control
  // character or one of UIKit's function-key sentinels -- the arrows, escape
  // and the F keys arrive as "UIKeyInput..." strings or in the private-use
  // range.
  bool isTypedText(NSString* characters) {
    if (characters.length == 0 || [characters hasPrefix:@"UIKeyInput"])
      return false;

    unichar first = [characters characterAtIndex:0];
    return first >= 0x20 && first != 0x7f && (first < 0xf700 || first > 0xf8ff);
  }

  // Hardware presses, for whichever of the two views holds first responder.
  // Down, a key sends the text it types and then the key itself, in the order
  // the macOS view sends them; its text goes nowhere unless a text entry is
  // focused, which the event handler decides. Returns the presses visage did
  // not use, for the caller to hand up the responder chain.
  NSSet<UIPress*>* sendPresses(WindowIos* window, NSSet<UIPress*>* presses, bool down) {
    NSMutableSet<UIPress*>* unused = [NSMutableSet set];
    for (UIPress* press in presses) {
      bool used = false;
      if (@available(iOS 13.4, *)) {
        UIKey* key = press.key;
        if (window != nullptr && key != nil) {
          KeyCode code = translateKeyCode(key.keyCode);
          int modifiers = keyboardModifiers(key.modifierFlags);
          if (down) {
            if ((modifiers & (kModifierCmd | kModifierMacCtrl)) == 0 && isTypedText(key.characters))
              used = window->handleTextInput([key.characters UTF8String]);
            used = window->handleKeyDown(code, modifiers, false) || used;
          }
          else
            used = window->handleKeyUp(code, modifiers);
        }
      }
      if (!used)
        [unused addObject:press];
    }
    return unused;
  }

  // The presses of a set that were handed up on the way down, which the
  // responder chain is owed on the way up. Removes them from the record.
  NSSet<UIPress*>* takeForwarded(NSMutableSet<UIPress*>* forwarded, NSSet<UIPress*>* presses) {
    NSMutableSet<UIPress*>* owed = [NSMutableSet setWithSet:presses];
    [owed intersectSet:forwarded];
    [forwarded minusSet:owed];
    return owed;
  }
}

@implementation VisageAppDelegate

- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)options {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  UIViewController* root = [[UIViewController alloc] init];
  self.window.rootViewController = root;

  visage::WindowIos* window = visage::standalone_window;
  if (window) {
    UIView* content = window->contentView();
    content.frame = root.view.bounds;
    content.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [root.view addSubview:content];

    CGFloat scale = [[UIScreen mainScreen] nativeScale];
    window->handleNativeResize(root.view.bounds.size.width * scale,
                               root.view.bounds.size.height * scale);
  }

  [self.window makeKeyAndVisible];
  return YES;
}

@end

// =============================================================================
// VisageMetalViewDelegate — drives the render loop
// =============================================================================

@implementation VisageMetalViewDelegate

- (instancetype)initWithWindow:(visage::WindowIos*)window {
  self = [super init];
  self.visage_window = window;
  self.start_microseconds = visage::time::microseconds();
  return self;
}

- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size {
  self.visage_window->handleNativeResize(size.width, size.height);
}

- (void)drawInMTKView:(MTKView*)view {
  if (!view.currentDrawable || !view.currentRenderPassDescriptor)
    return;

  view.layer.contentsScale = self.visage_window->dpiScale();
  long long ms = visage::time::microseconds();
  self.visage_window->drawCallback((ms - self.start_microseconds) / 1000000.0);

  // Text entry starts and ends inside visage, on a touch or a key, with no
  // call out to say so; the frame tick is where the keyboard catches up.
  if ([view isKindOfClass:[VisageMetalView class]])
    [(VisageMetalView*)view syncTextInput];
}

@end

// =============================================================================
// VisageTextInputView — the software keyboard's target during text entry
// =============================================================================

@implementation VisageTextInputView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  self.userInteractionEnabled = NO;
  self.forwarded_presses = [NSMutableSet set];

  // Names and numbers, not prose: nothing the keyboard offers to change is
  // wanted, and a capital forced onto the first letter would be a surprise.
  self.autocorrectionType = UITextAutocorrectionTypeNo;
  self.autocapitalizationType = UITextAutocapitalizationTypeNone;
  self.spellCheckingType = UITextSpellCheckingTypeNo;
  self.smartQuotesType = UITextSmartQuotesTypeNo;
  self.smartDashesType = UITextSmartDashesTypeNo;
  self.smartInsertDeleteType = UITextSmartInsertDeleteTypeNo;
  self.returnKeyType = UIReturnKeyDone;

  // No shortcuts bar over a hardware keyboard: there is nothing on it to
  // offer a field this size.
  self.inputAssistantItem.leadingBarButtonGroups = @[];
  self.inputAssistantItem.trailingBarButtonGroups = @[];
  return self;
}

- (BOOL)canBecomeFirstResponder {
  return YES;
}

- (BOOL)hasText {
  // Always, so the keyboard's delete key is always sent: whether there is
  // anything behind the caret is the text entry's to know.
  return YES;
}

- (void)insertText:(NSString*)text {
  if (self.visage_window == nullptr)
    return;

  // The software keyboard's return key arrives as a newline; visage's text
  // entries take it as the Return key, as a hardware keyboard sends it.
  if ([text isEqualToString:@"\n"]) {
    self.visage_window->handleKeyDown(visage::KeyCode::Return, 0, false);
    self.visage_window->handleKeyUp(visage::KeyCode::Return, 0);
    return;
  }

  self.visage_window->handleTextInput([text UTF8String]);
}

- (void)deleteBackward {
  if (self.visage_window == nullptr)
    return;

  self.visage_window->handleKeyDown(visage::KeyCode::Backspace, 0, false);
  self.visage_window->handleKeyUp(visage::KeyCode::Backspace, 0);
}

// A hardware key's text is sent from its press, so the presses visage uses
// are never handed on: the text system would type the same character again
// through insertText.
- (void)pressesBegan:(NSSet<UIPress*>*)presses withEvent:(UIPressesEvent*)event {
  NSSet<UIPress*>* unused = visage::sendPresses(self.visage_window, presses, true);
  if (unused.count) {
    [self.forwarded_presses unionSet:unused];
    [super pressesBegan:unused withEvent:event];
  }
}

- (void)pressesChanged:(NSSet<UIPress*>*)presses withEvent:(UIPressesEvent*)event {
  NSMutableSet<UIPress*>* owed = [NSMutableSet setWithSet:presses];
  [owed intersectSet:self.forwarded_presses];
  if (owed.count)
    [super pressesChanged:owed withEvent:event];
}

- (void)pressesEnded:(NSSet<UIPress*>*)presses withEvent:(UIPressesEvent*)event {
  visage::sendPresses(self.visage_window, presses, false);
  NSSet<UIPress*>* owed = visage::takeForwarded(self.forwarded_presses, presses);
  if (owed.count)
    [super pressesEnded:owed withEvent:event];
}

- (void)pressesCancelled:(NSSet<UIPress*>*)presses withEvent:(UIPressesEvent*)event {
  visage::sendPresses(self.visage_window, presses, false);
  NSSet<UIPress*>* owed = visage::takeForwarded(self.forwarded_presses, presses);
  if (owed.count)
    [super pressesCancelled:owed withEvent:event];
}

@end

// =============================================================================
// VisageMetalView — MTKView subclass with touch event handling
// =============================================================================

@implementation VisageMetalView

- (instancetype)initWithFrame:(CGRect)frame inWindow:(visage::WindowIos*)window {
  self = [super initWithFrame:frame];
  self.visage_window = window;
  self.device = MTLCreateSystemDefaultDevice();
  self.clearColor = MTLClearColorMake(0.1, 0.1, 0.1, 1.0);
  self.enableSetNeedsDisplay = NO;
  self.framebufferOnly = YES;
  self.preferredFramesPerSecond = 60;
  self.multipleTouchEnabled = YES;
  self.active_touches = [NSMapTable weakToStrongObjectsMapTable];
  self.next_pointer_id = 0;
  self.forwarded_presses = [NSMutableSet set];

  // A child, so it is in the window whenever this view is and can take
  // first responder the moment a text entry wants the keyboard.
  self.text_input = [[VisageTextInputView alloc] initWithFrame:CGRectZero];
  self.text_input.visage_window = window;
  [self addSubview:self.text_input];
  return self;
}

// ---------------------------------------------------------------------------
// Keyboard
//
// This view takes hardware keys whenever it holds first responder. It does
// not adopt UIKeyInput, so holding it never brings the software keyboard up;
// during text entry first responder moves to the text input child, whose
// UIKeyInput does. A touch on the view claims the keyboard for whichever of
// the two should have it.
// ---------------------------------------------------------------------------

- (BOOL)canBecomeFirstResponder {
  return YES;
}

- (void)syncTextInput {
  bool text_entry = self.visage_window && self.visage_window->hasActiveTextEntry();
  if (text_entry == self.text_entry_shown)
    return;

  self.text_entry_shown = text_entry;
  if (text_entry)
    [self.text_input becomeFirstResponder];
  else if (self.text_input.isFirstResponder)
    [self becomeFirstResponder];
}

- (void)claimKeyboard {
  bool text_entry = self.visage_window && self.visage_window->hasActiveTextEntry();
  self.text_entry_shown = text_entry;

  UIResponder* wanted = text_entry ? (UIResponder*)self.text_input : (UIResponder*)self;
  if (!wanted.isFirstResponder)
    [wanted becomeFirstResponder];
}

- (void)pressesBegan:(NSSet<UIPress*>*)presses withEvent:(UIPressesEvent*)event {
  NSSet<UIPress*>* unused = visage::sendPresses(self.visage_window, presses, true);
  if (unused.count) {
    [self.forwarded_presses unionSet:unused];
    [super pressesBegan:unused withEvent:event];
  }
}

- (void)pressesChanged:(NSSet<UIPress*>*)presses withEvent:(UIPressesEvent*)event {
  NSMutableSet<UIPress*>* owed = [NSMutableSet setWithSet:presses];
  [owed intersectSet:self.forwarded_presses];
  if (owed.count)
    [super pressesChanged:owed withEvent:event];
}

- (void)pressesEnded:(NSSet<UIPress*>*)presses withEvent:(UIPressesEvent*)event {
  visage::sendPresses(self.visage_window, presses, false);
  NSSet<UIPress*>* owed = visage::takeForwarded(self.forwarded_presses, presses);
  if (owed.count)
    [super pressesEnded:owed withEvent:event];
}

- (void)pressesCancelled:(NSSet<UIPress*>*)presses withEvent:(UIPressesEvent*)event {
  visage::sendPresses(self.visage_window, presses, false);
  NSSet<UIPress*>* owed = visage::takeForwarded(self.forwarded_presses, presses);
  if (owed.count)
    [super pressesCancelled:owed withEvent:event];
}

// ---------------------------------------------------------------------------
// Touch → mouse event mapping (multi-touch)
//
// Each UITouch gets a stable pointer_id (0 for first touch, incrementing for
// subsequent touches). Coordinates are in UIView space (top-left origin,
// points) scaled by dpiScale() to native pixels — same coordinate system
// Visage uses internally.
//
// pointer_id 0 = primary touch (drives keyboard focus, hover, drag-drop)
// pointer_id > 0 = additional simultaneous touches
// ---------------------------------------------------------------------------

- (visage::Point)touchPosition:(UITouch*)touch {
  CGPoint location = [touch locationInView:self];
  float scale = self.visage_window->dpiScale();
  return visage::Point(location.x * scale, location.y * scale);
}

- (int)assignPointerId:(UITouch*)touch {
  NSNumber* existing = [self.active_touches objectForKey:touch];
  if (existing)
    return [existing intValue];

  int pid = self.next_pointer_id++;
  [self.active_touches setObject:@(pid) forKey:touch];
  return pid;
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event {
  NSArray<UITouch*>* sorted = [[touches allObjects]
      sortedArrayUsingComparator:^NSComparisonResult(UITouch* a, UITouch* b) {
        CGPoint pa = [a locationInView:self];
        CGPoint pb = [b locationInView:self];
        if (pa.x != pb.x) return pa.x < pb.x ? NSOrderedAscending : NSOrderedDescending;
        if (pa.y != pb.y) return pa.y < pb.y ? NSOrderedAscending : NSOrderedDescending;
        return NSOrderedSame;
      }];

  for (UITouch* touch in sorted) {
    int pid = [self assignPointerId:touch];
    visage::Point point = [self touchPosition:touch];
    self.visage_window->handleMouseDown(visage::kMouseButtonLeft, point.x, point.y,
                                        visage::kMouseButtonLeft, 0, pid);
  }
}

- (void)touchesMoved:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event {
  for (UITouch* touch in touches) {
    NSNumber* pid_num = [self.active_touches objectForKey:touch];
    if (!pid_num)
      continue;

    int pid = [pid_num intValue];
    visage::Point point = [self touchPosition:touch];
    self.visage_window->handleMouseMove(point.x, point.y, visage::kMouseButtonLeft, 0, pid);
  }
}

- (void)touchesEnded:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event {
  for (UITouch* touch in touches) {
    NSNumber* pid_num = [self.active_touches objectForKey:touch];
    if (!pid_num)
      continue;

    int pid = [pid_num intValue];
    visage::Point point = [self touchPosition:touch];
    self.visage_window->handleMouseUp(visage::kMouseButtonLeft, point.x, point.y, 0, 0, pid);
    [self.active_touches removeObjectForKey:touch];
  }

  if ([self.active_touches count] == 0)
    self.next_pointer_id = 0;

  // After visage has seen the whole tap, so a text entry it focused on the
  // way is already the one asking for the keyboard.
  [self claimKeyboard];
}

- (void)touchesCancelled:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event {
  for (UITouch* touch in touches) {
    NSNumber* pid_num = [self.active_touches objectForKey:touch];
    if (!pid_num)
      continue;

    int pid = [pid_num intValue];
    visage::Point point = [self touchPosition:touch];
    self.visage_window->handleMouseUp(visage::kMouseButtonLeft, point.x, point.y, 0, 0, pid);
    [self.active_touches removeObjectForKey:touch];
  }

  if ([self.active_touches count] == 0)
    self.next_pointer_id = 0;
}

@end

// =============================================================================
// WindowIos implementation
// =============================================================================

namespace visage {

  WindowIos::WindowIos(int width, int height, float scale)
      : Window(width, height) {
    setDpiScale(scale);
    CGRect frame = CGRectMake(0.0f, 0.0f, width / scale, height / scale);
    view_ = [[VisageMetalView alloc] initWithFrame:frame inWindow:this];
    view_delegate_ = [[VisageMetalViewDelegate alloc] initWithWindow:this];
    view_.delegate = view_delegate_;
  }

  WindowIos::WindowIos(int width, int height, float scale, void* parent_handle)
      : Window(width, height) {
    setDpiScale(scale);
    parent_view_ = (__bridge UIView*)parent_handle;
    CGRect frame = CGRectMake(0.0f, 0.0f, width / scale, height / scale);
    view_ = [[VisageMetalView alloc] initWithFrame:frame inWindow:this];
    view_delegate_ = [[VisageMetalViewDelegate alloc] initWithWindow:this];
    view_.delegate = view_delegate_;

    if (parent_view_)
      [parent_view_ addSubview:view_];
  }

  WindowIos::~WindowIos() {
    view_.visage_window = nullptr;
    view_.text_input.visage_window = nullptr;
    if (parent_view_)
      [view_ removeFromSuperview];
  }

  void WindowIos::runEventLoop() {
    // Embedded (AUv3): the host owns the app and the run loop already turns.
    if (parent_view_) {
      [[NSRunLoop mainRunLoop] run];
      return;
    }

    // Standalone: hand off to UIKit. UIApplicationMain does not return, which
    // matches what callers expect of runEventLoop.
    visage::standalone_window = this;
    @autoreleasepool {
      UIApplicationMain(0, nullptr, nil, NSStringFromClass([VisageAppDelegate class]));
    }
  }

  UIView* WindowIos::contentView() const {
    return view_;
  }

  void* WindowIos::initWindow() const {
    return (__bridge void*)InitialMetalLayer::layer();
  }

  void WindowIos::windowContentsResized(int width, int height) {
    float scale = dpiScale();
    [view_ setFrame:CGRectMake(0.0f, 0.0f, width / scale, height / scale)];
  }

  void WindowIos::show() {
    view_.hidden = NO;
    handleWindowShown();
  }

  void WindowIos::showMaximized() {
    show();
  }

  void WindowIos::hide() {
    view_.hidden = YES;
    handleWindowHidden();
  }

  void WindowIos::close() {
    hide();
    [view_ removeFromSuperview];
  }

  bool WindowIos::isShowing() const {
    return view_ != nil && !view_.hidden;
  }

  void WindowIos::setWindowTitle(const std::string& title) {
    // No window chrome on iOS
  }

  IPoint WindowIos::maxWindowDimensions() const {
    CGRect screen = [[UIScreen mainScreen] bounds];
    float scale = [[UIScreen mainScreen] nativeScale];
    return { static_cast<int>(screen.size.width * scale),
             static_cast<int>(screen.size.height * scale) };
  }

  void WindowIos::handleNativeResize(int width, int height) {
    handleResized(width, height);
  }

  // ---------------------------------------------------------------------------
  // Factory functions
  // ---------------------------------------------------------------------------

  std::unique_ptr<Window> createWindow(const Dimension& x, const Dimension& y,
                                       const Dimension& width, const Dimension& height,
                                       Window::Decoration decoration_style) {
    float scale = defaultDpiScale();
    IBounds bounds = computeWindowBounds(x, y, width, height);
    return std::make_unique<WindowIos>(bounds.width(), bounds.height(), scale);
  }

  std::unique_ptr<Window> createPluginWindow(const Dimension& width, const Dimension& height,
                                             void* parent_handle) {
    float scale = defaultDpiScale();
    CGRect screen = [[UIScreen mainScreen] bounds];
    int screen_width = static_cast<int>(screen.size.width * scale);
    int screen_height = static_cast<int>(screen.size.height * scale);
    int w = width.computeInt(scale, screen_width, screen_height);
    int h = height.computeInt(scale, screen_width, screen_height);
    return std::make_unique<WindowIos>(w, h, scale, parent_handle);
  }

  // ---------------------------------------------------------------------------
  // Global utility functions
  // ---------------------------------------------------------------------------

  bool isMobileDevice() { return true; }

  float defaultDpiScale() {
    return static_cast<float>([[UIScreen mainScreen] nativeScale]);
  }

  IBounds computeWindowBounds(const Dimension& x, const Dimension& y,
                              const Dimension& width, const Dimension& height) {
    float scale = defaultDpiScale();
    CGRect screen = [[UIScreen mainScreen] bounds];
    int screen_width = static_cast<int>(screen.size.width * scale);
    int screen_height = static_cast<int>(screen.size.height * scale);

    int w = width.computeInt(scale, screen_width, screen_height);
    int h = height.computeInt(scale, screen_width, screen_height);
    int px = x.computeInt(scale, screen_width, screen_height);
    int py = y.computeInt(scale, screen_width, screen_height);
    return { px, py, px + w, py + h };
  }

  void setCursorStyle(MouseCursor style) { }
  void setCursorVisible(bool visible) { }

  Point cursorPosition() { return { 0.0f, 0.0f }; }
  void setCursorPosition(Point window_position) { }
  void setCursorScreenPosition(Point screen_position) { }

  void showMessageBox(std::string title, std::string message) {
    dispatch_async(dispatch_get_main_queue(), ^{
      UIAlertController* alert =
          [UIAlertController alertControllerWithTitle:[NSString stringWithUTF8String:title.c_str()]
                                             message:[NSString stringWithUTF8String:message.c_str()]
                                      preferredStyle:UIAlertControllerStyleAlert];
      [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                style:UIAlertActionStyleDefault
                                              handler:nil]];
      UIWindow* activeWindow = nil;
      for (UIScene* scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
          UIWindowScene* windowScene = (UIWindowScene*)scene;
          for (UIWindow* window in windowScene.windows) {
            if (window.isKeyWindow) { activeWindow = window; break; }
          }
          if (activeWindow) break;
        }
      }
      UIViewController* root = activeWindow.rootViewController;
      if (root)
        [root presentViewController:alert animated:YES completion:nil];
    });
  }

  std::string readClipboardText() {
    UIPasteboard* pb = [UIPasteboard generalPasteboard];
    return pb.string ? std::string([pb.string UTF8String]) : std::string();
  }

  void setClipboardText(const std::string& text) {
    [UIPasteboard generalPasteboard].string =
        [NSString stringWithUTF8String:text.c_str()];
  }

  void closeApplication() { }
}

#endif
