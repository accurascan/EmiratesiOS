//
//  Accura.h
//  AccuraSDK
//
//  Created by kuldeep on 12/16/19.
//  Copyright © 2019 Elite Development LLC. All rights reserved.
//

#ifndef Accura_h
#define Accura_h
#include "opencv2/opencv.hpp"
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/core/core.hpp>
#import <vector>
#include <string>
#include <queue>
#include <regex>
#include <map>
#include "json.hpp"
#include "base64.h"

using namespace cv;
using namespace std;


struct Data_t {
    std::string key_;
    std::string data_;
    
    Data_t(std::string key_v, std::string data_v) : key_(key_v), data_(data_v) {}
};

class ImageOpenCv {
    
public:
    ImageOpenCv(const string &message, bool isSucess, bool isChangeCard, int cardPos,
                int resultCode, float ratioOut, map<int, Data_t> mapData) : message(message),
    isSucess(isSucess),
    isChangeCard(
                 isChangeCard),
    cardPos(cardPos),
    resultCode(
               resultCode),
    ratioOut(ratioOut),
    mapData(mapData) {
    }
    
    string message = "";
    bool isSucess = false;
    bool isChangeCard = false;
    int cardPos = 0;
    int resultCode = 0;
    float ratioOut;
    map<int, Data_t> mapData;
};

class PrimaryData {
public:
    PrimaryData(const string &imageName, const string &cardSide, const bool &isFront,
                int cardPos, float refWidth, float refHeight, int imgHeight,
                vector<string> rect)
    : imageName(imageName), cardSide(cardSide), isFront(isFront), cardPos(cardPos),
    refWidth(refWidth), refHeight(refHeight), imgHeight(imgHeight), rect(rect) {}
    
    string imageName = "";
    string cardSide = "";
    bool isFront = true;
    int cardPos = 0;
    float refWidth = 0;
    float refHeight = 0;
    int imgHeight = 0;
    vector<string> rect;
};

ImageOpenCv
checkCardInFrameOrNot(Mat &refMat, Mat &src, Mat &resultMat, string basicString, bool isHologram);

PrimaryData
setTemplateFirst(Mat &outMat, nlohmann::json wholeresponce1, string string1, int i1);

nlohmann::json jsonData();

int doCheckData(cv::Mat rgbMat, int w, int h);

#endif /* Accura_h */
