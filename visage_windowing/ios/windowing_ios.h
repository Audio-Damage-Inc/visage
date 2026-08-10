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

#pragma once

#if VISAGE_IOS
#include "windowing.h"

#import <UIKit/UIKit.h>
#import <MetalKit/MetalKit.h>

namespace visage {
  class WindowIos;
}

@interface VisageMetalViewDelegate : NSObject <MTKViewDelegate>
@property(nonatomic) visage::WindowIos* visage_window;
@property long long start_microseconds;
@end

@interface VisageMetalView : MTKView
@property(nonatomic) visage::WindowIos* visage_window;
@property(nonatomic, strong) NSMapTable<UITouch*, NSNumber*>* active_touches;
@property(nonatomic) int next_pointer_id;

- (instancetype)initWithFrame:(CGRect)frame inWindow:(visage::WindowIos*)window;
@end

// Standalone apps only. An embedded window (AUv3) is handed a parent UIView by
// the host, but a standalone one has no UIApplication at all until this runs:
// visage's event loop is an NSRunLoop, which never starts UIKit's lifecycle.
@interface VisageAppDelegate : UIResponder <UIApplicationDelegate>
@property(nonatomic, strong) UIWindow* window;
@end

namespace visage {
  class WindowIos : public Window {
  public:
    WindowIos(int width, int height, float scale);
    WindowIos(int width, int height, float scale, void* parent_handle);
    ~WindowIos() override;

    void runEventLoop() override;
    void* nativeHandle() const override { return (__bridge void*)view_; }
    void* initWindow() const override;
    void windowContentsResized(int width, int height) override;
    void show() override;
    void showMaximized() override;
    void hide() override;
    void close() override;
    bool isShowing() const override;
    void setWindowTitle(const std::string& title) override;
    IPoint maxWindowDimensions() const override;

    void handleNativeResize(int width, int height);
    // The Metal view, for the standalone app delegate to install in its window.
    UIView* contentView() const;

  private:
    UIView* parent_view_ = nullptr;
    VisageMetalView* view_ = nil;
    VisageMetalViewDelegate* view_delegate_ = nil;
  };
}

#endif
