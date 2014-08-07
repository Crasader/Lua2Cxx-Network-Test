#include "AppDelegate.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "cocos2d.h"

using namespace CocosDenshion;

USING_NS_CC;
using namespace std;

AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();
}

bool AppDelegate::applicationDidFinishLaunching()
{
    // initialize director
    auto director = Director::getInstance();
	auto glview = director->getOpenGLView();
	if(!glview) {
		glview = GLView::createWithRect("networkTest", Rect(0,0,900,640));
		director->setOpenGLView(glview);
	}

    Size frameSize = glview->getFrameSize();
    Size designSize = Size(1136,640);
    float scaleX = frameSize.width/designSize.width;
    float scaleY = frameSize.height/designSize.height;
    if (scaleX < scaleY) {
        glview->setDesignResolutionSize(designSize.width, designSize.height, ResolutionPolicy::FIXED_WIDTH);
    }
    else{
        glview->setDesignResolutionSize(designSize.width, designSize.height, ResolutionPolicy::FIXED_HEIGHT);
    }

    // turn on display FPS
    director->setDisplayStats(true);

    // set FPS. the default value is 1.0/60 if you don't call this
    director->setAnimationInterval(1.0 / 60);
    
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    
    std::vector<std::string> searchPaths;
    searchPaths.push_back("src");
    searchPaths.push_back("res");
    FileUtils::getInstance()->setSearchPaths(searchPaths);
    
    //set network
    net::MessageManager::getInstance()->connect();
    net::MessageManager::getInstance()->setLuaState(engine->getLuaStack()->getLuaState());
    net::MessageManager::getInstance()->run();
    
    
    
    if (engine->executeScriptFile("main.lua")) {
        return false;
    }

    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    Director::getInstance()->stopAnimation();

    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    Director::getInstance()->startAnimation();

    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
}
