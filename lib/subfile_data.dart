import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class DataProcessor {
  String dat;
  int amountChopped;

  DataProcessor(this.dat, this.amountChopped);

  String chopAndAssign(int length) {
    String result = dat.substring(0, length * 2);
    try {
      dat =
          dat.substring(length * 2); // upper bound of the length of the string
      amountChopped += length * 2;
    } catch (e) {
      print(e);
      print("length in data left is ${dat.length * 2}");
      print("length * 2 to chop is: ${length * 2}");
      print("amount chopped is: ${amountChopped}");
      dat = dat.substring(length * 2);
    }
    return result;
  }

  String nextFourBytes() {
    return dat.substring(0, 8);
  }

  String hexPosition() {
    return (amountChopped ~/ 2).toRadixString(16);
  }
}

class SubFileData extends ChangeNotifier {
  List<String> splitAtExcl(String str, int index) {
    return [str.substring(0, index), str.substring(index, str.length)];
  }

  late String offset;
  late String lenDataBytes;
  String bytes;
  late String otherBytes;
  late String emBytes;
  // assuming emitter has size 0x14c
  late String emitterShape;
  late String emitterLife;
  late String particleLife;
  late String particleLifeRandom;
  late String inheritChildParticleTranslation;
  late String emitIntervalRand;
  late String emitRandom;
  late String emissionRate;
  late String emitStart;
  late String emitEnd;
  late String emitInterval;
  late String inheritParticleTranslation;
  late String inheritChildEmmitterTransformation;
  late String emitterDim1;
  late String emitterDim2;
  late String emitterDim3;
  late String emitterDim4;
  late String emitterDim5;
  late String emitterDim6;
  late String emitDiversion;
  late String randomVel;
  late String unknownFlags;
  late String emitFlags;
  late String randomMoment;
  late String powerRadiation;
  late String powerYAxisVal;
  late String powerRandom;
  late String powerNormal;
  late String diffEmitNormal;
  late String powerSpec;
  late String diffSpec;
  late String emAngle;
  late String scale;
  late String rot;
  late String transl;
  late String LODNearest;
  late String LODFurthest;
  late String LODMinEm;
  late String LODAlpha;
  late String randSeed;
  late String unknown0;
  late String drawFlagsBitfield;
  late String alphaComp0;
  late String alphaComp1;
  late String alphaCompOperation;
  late String numTEVStages;
  late String unknown1;
  late String indTEVEnabled;
  late String textureUsedTEV;
  late String TEVColInputSourcesA;
  late String TEVColInputSourcesB;
  late String TEVColInputSourcesC;
  late String TEVColInputSourcesD;
  late String TEV1Operation;
  late String TEV1Bias;
  late String TEV1Scale;
  late String TEV1Clamp;
  late String TEV1OutRegister;
  late String TEV2Operation;
  late String TEV2Bias;
  late String TEV2Scale;
  late String TEV2Clamp;
  late String TEV2OutRegister;
  late String TEV3Operation;
  late String TEV3Bias;
  late String TEV3Scale;
  late String TEV3Clamp;
  late String TEV3OutRegister;
  late String TEV4Operation;
  late String TEV4Bias;
  late String TEV4Scale;
  late String TEV4Clamp;
  late String TEV4OutRegister;
  late String TEV1AlphaInput;
  late String TEV2AlphaInput;
  late String TEV3AlphaInput;
  late String TEV4AlphaInput;
  late String alphaTEV1Operations;
  late String alphaTEV1Bias;
  late String alphaTEV1Scale;
  late String alphaTEV1Clamp;
  late String alphaTEV1OutRegister;
  late String alphaTEV2Operations;
  late String alphaTEV2Bias;
  late String alphaTEV2Scale;
  late String alphaTEV2Clamp;
  late String alphaTEV2OutRegister;
  late String alphaTEV3Operations;
  late String alphaTEV3Bias;
  late String alphaTEV3Scale;
  late String alphaTEV3Clamp;
  late String alphaTEV3OutRegister;
  late String alphaTEV4Operations;
  late String alphaTEV4Bias;
  late String alphaTEV4Scale;
  late String alphaTEV4Clamp;
  late String alphaTEV4OutRegister;
  late String constColSelectors;
  late String constAlphaSelectors;
  late String blendModeType;
  late String blendSourceFactor;
  late String blendDestFactor;
  late String blendOperation;
  late String assignPartColTEVColRegisters;
  late String assignPartAlphTEVAlphRegisters;
  late String ZCompFunct;
  late String alphFlickType;
  late String alphFlickCycleLen;
  late String alphFlickMaxCycleRandDev;
  late String alphFlickAmpl;
  late String lightingMode;
  late String lightingType;
  late String lightingAmbCol;
  late String lightDiffCol;
  late String lightRadius;
  late String lightPosX;
  late String lightPosY;
  late String lightPosZ;
  late String indTexMat1;
  late String indTexMat2;
  late String indTexMat3;
  late String indTexMat4;
  late String indTexMat5;
  late String indTexMat6;
  late String indTexMatScale; //sbyte
  late String pivotX;
  late String pivotY;
  late String padding0;
  late String particleType;
  late String particleTypeOpt;
  late String movementType;
  late String rotAxis;
  late String gabiHelp0;
  late String gabiHelp1;
  late String gabiHelp2;
  late String padding1;
  late String zOffset;
  late String lenParticleDat;

  ////// PARTICLE
  late String partBytes;
  late String col1Primary;
  late String col1Secondary;
  late String col2Primary;
  late String col2Secondary;
  late String sizePart;
  late String scalePart;
  late String rotPart;
  late String texScale1;
  late String texScale2;
  late String texScale3;
  late String texRot;
  late String texTrans1;
  late String texTrans2;
  late String texTrans3;
  late String mTexture1;
  late String mTexture2;
  late String mTexture3;
  late String textureWrap;
  late String textureReverse;
  late String alphaCompRef0;
  late String alphaCompRef1;
  late String rotOffsetRand1;
  late String rotOffsetRand2;
  late String rotOffsetRand3;
  late String rotOffset;
  late String lenTexRef1;
  late String texRef1;
  late String lenTexRef2;
  late String texRef2;
  late String lenTexRef3;
  late String texRef3;
  ////// ANIMATION
  late String animationData;

  SubFileData(
      {required this.bytes,
      required String this.offset,
      required String this.lenDataBytes}) {
    print(
        "am in subfile_data. offset is ${offset}, not-hex = ${int.parse(offset, radix: 16)} lenDataBytes is ${int.parse(lenDataBytes, radix: 16)} (hex = ${lenDataBytes})");
    // I could clean up the logic here to make it more
    // stylistically consistant with the other constructors
    bytes = bytes.substring(int.parse(offset, radix: 16));
    String thisBytes =
        splitAtExcl(bytes, int.parse(lenDataBytes, radix: 16) * 2)[
            0]; // don't I pass in lenDataBytes times two?
    print("our thisBytes is $thisBytes");
    otherBytes =
        splitAtExcl(thisBytes, int.parse(lenDataBytes, radix: 16) * 2)[1];
    thisBytes = splitAtExcl(thisBytes, 8)[1];
    int emSizeInt = int.parse(splitAtExcl(thisBytes, 8)[0], radix: 16);
    print("emSizeInt is $emSizeInt");
    thisBytes = splitAtExcl(thisBytes, 8)[1];
    String emData = splitAtExcl(
        thisBytes, emSizeInt * 2)[0]; // the first header is already read
    // times 2 because underpinning representation
    print("emData is $emData");
    String partAndAnimData = splitAtExcl(thisBytes, emSizeInt * 2)[1];
    print("partAndAnimData has size ${partAndAnimData.length}");
    print("partAndAnimData is $partAndAnimData");

    parseThis(emData, partAndAnimData);
  }

  String getStr() {
    debugPrint("we are now writing a subfile data");
    StringBuffer out = StringBuffer();
    out.write("0000"); // pointer to effect name
    out.write(emBytes);
    out.write(unknownFlags);
    out.write(emitFlags);
    out.write(emitterShape);
    out.write(emitterLife);
    out.write(particleLife);
    out.write(particleLifeRandom);
    out.write(inheritChildParticleTranslation);
    out.write(emitIntervalRand);
    out.write(emitRandom);
    out.write(emissionRate);
    out.write(emitStart);
    out.write(emitEnd);
    out.write(emitInterval);
    out.write(inheritParticleTranslation);
    out.write(inheritChildEmmitterTransformation);
    out.write(emitterDim1);
    out.write(emitterDim2);
    out.write(emitterDim3);
    out.write(emitterDim4);
    out.write(emitterDim5);
    out.write(emitterDim6);
    out.write(emitDiversion);
    out.write(randomVel);
    out.write(randomMoment);
    out.write(randomMoment);
    out.write(powerRadiation);
    out.write(powerYAxisVal);
    out.write(powerRandom);
    out.write(powerNormal);
    out.write(diffEmitNormal);
    out.write(powerSpec);
    out.write(diffSpec);
    out.write(emAngle);
    out.write(scale);
    out.write(rot);
    out.write(transl);
    out.write(LODNearest);
    out.write(LODFurthest);
    out.write(LODMinEm);
    out.write(LODAlpha);
    out.write(randSeed);
    out.write(unknown0);
    out.write(drawFlagsBitfield);
    out.write(alphaComp0);
    out.write(alphaComp1);
    out.write(alphaCompOperation);
    out.write(numTEVStages);
    out.write(unknown1);
    out.write(indTEVEnabled);
    out.write(textureUsedTEV);
    out.write(TEVColInputSourcesA);
    out.write(TEVColInputSourcesB);
    out.write(TEVColInputSourcesC);
    out.write(TEVColInputSourcesD);
    out.write(TEV1Operation);
    out.write(TEV1Bias);
    out.write(TEV1Scale);
    out.write(TEV1Clamp);
    out.write(TEV1OutRegister);
    out.write(TEV2Operation);
    out.write(TEV2Bias);
    out.write(TEV2Scale);
    out.write(TEV2Clamp);
    out.write(TEV2OutRegister);
    out.write(TEV3Operation);
    out.write(TEV3Bias);
    out.write(TEV3Scale);
    out.write(TEV3Clamp);
    out.write(TEV3OutRegister);
    out.write(TEV4Operation);
    out.write(TEV4Bias);
    out.write(TEV4Scale);
    out.write(TEV4Clamp);
    out.write(TEV4OutRegister);
    out.write(TEV1AlphaInput);
    out.write(TEV2AlphaInput);
    out.write(TEV3AlphaInput);
    out.write(TEV4AlphaInput);
    out.write(alphaTEV1Operations);
    out.write(alphaTEV1Bias);
    out.write(alphaTEV1Scale);
    out.write(alphaTEV1Clamp);
    out.write(alphaTEV1OutRegister);
    out.write(alphaTEV2Operations);
    out.write(alphaTEV2Bias);
    out.write(alphaTEV2Scale);
    out.write(alphaTEV2Clamp);
    out.write(alphaTEV2OutRegister);
    out.write(alphaTEV3Operations);
    out.write(alphaTEV3Bias);
    out.write(alphaTEV3Scale);
    out.write(alphaTEV3Clamp);
    out.write(alphaTEV3OutRegister);
    out.write(alphaTEV4Operations);
    out.write(alphaTEV4Bias);
    out.write(alphaTEV4Scale);
    out.write(alphaTEV4Clamp);
    out.write(alphaTEV4OutRegister);
    out.write(constColSelectors);
    out.write(constAlphaSelectors);
    out.write(blendModeType);
    out.write(blendSourceFactor);
    out.write(blendDestFactor);
    out.write(blendOperation);
    out.write(assignPartColTEVColRegisters);
    out.write(assignPartAlphTEVAlphRegisters);
    out.write(ZCompFunct);
    out.write(alphFlickType);
    out.write(alphFlickCycleLen);
    out.write(alphFlickMaxCycleRandDev);
    out.write(alphFlickAmpl);
    out.write(lightingMode);
    out.write(lightingType);
    out.write(lightingAmbCol);
    out.write(lightDiffCol);
    out.write(lightRadius);
    out.write(lightPosX);
    out.write(lightPosY);
    out.write(lightPosZ);
    out.write(indTexMat1);
    out.write(indTexMat2);
    out.write(indTexMat3);
    out.write(indTexMat4);
    out.write(indTexMat5);
    out.write(indTexMat6);
    out.write(indTexMatScale);
    out.write(pivotX);
    out.write(pivotY);
    out.write(padding0);
    out.write(particleType);
    out.write(particleTypeOpt);
    out.write(movementType);
    out.write(rotAxis);
    out.write(gabiHelp0);
    out.write(gabiHelp1);
    out.write(gabiHelp2);
    out.write(padding1);
    out.write(zOffset);
    String outStr = "";
    if (out.toString().length != int.parse(emBytes, radix: 16)) {
      print(out.toString());
      print(out.toString().length);
      print(emBytes);
      print(int.parse(emBytes));
    } else {
      outStr = out.toString().padRight(int.parse(emBytes, radix: 16));
    }
    StringBuffer out2 = StringBuffer();
    // particle
    out2.write(lenParticleDat);
    out2.write(partBytes);
    out2.write(col1Primary);
    out2.write(col1Secondary);
    out2.write(col2Primary);
    out2.write(col2Secondary);
    out2.write(sizePart);
    out2.write(scalePart);
    out2.write(rotPart);
    out2.write(texScale1);
    out2.write(texScale2);
    out2.write(texScale3);
    out2.write(texRot);
    out2.write(texTrans1);
    out2.write(texTrans2);
    out2.write(texTrans3);
    out2.write(mTexture1);
    out2.write(mTexture2);
    out2.write(mTexture3);
    out2.write(textureWrap);
    out2.write(textureReverse);
    out2.write(alphaCompRef0);
    out2.write(alphaCompRef1);
    out2.write(rotOffsetRand1);
    out2.write(rotOffsetRand2);
    out2.write(rotOffsetRand3);
    out2.write(rotOffset);
    out2.write(lenTexRef1);
    out2.write(texRef1);
    out2.write(lenTexRef2);
    out2.write(texRef2);
    out2.write(lenTexRef3);
    out2.write(texRef3);
    String outStr2 = "";
    if (out2.toString().length != int.parse(partBytes, radix: 16)) {
      debugPrint("uh oh. particle data is wrong");
      debugPrint(out2.toString());
      debugPrint(out2.toString().length.toString());
      debugPrint(partBytes);
      debugPrint(int.parse(partBytes).toString());
    } else {
      outStr2 = out2.toString().padRight(int.parse(partBytes, radix: 16));
    }
    String outStr3 = animationData; // not implemented
    return "$outStr$outStr2$outStr3";
  }

  void parseThis(emData, partAndAnimData) {
    debugPrint("we are now parsing our subfile_data");
    DataProcessor emProc = DataProcessor(emData, 0);
    debugPrint(
        "our first four bytes of subfile_data should be, ${emProc.nextFourBytes()}");
    debugPrint("our hex offset is, ${emProc.hexPosition()} maybe + 80");
    unknown0 = emProc.chopAndAssign(4);
    debugPrint("our unknown0 is ${unknown0}");
    emitFlags = emProc.chopAndAssign(3);
    debugPrint("our hex offset is, ${emProc.hexPosition()}");
    debugPrint("our emitFlags is, ${emitFlags}");
    emitterShape = emProc.chopAndAssign(1);
    emitterLife = emProc.chopAndAssign(2);
    debugPrint("And the next bytes of this: ${emProc.nextFourBytes()}");
    particleLife = emProc.chopAndAssign(2);
    particleLifeRandom = emProc.chopAndAssign(1);
    inheritChildParticleTranslation = emProc.chopAndAssign(1);
    emitIntervalRand = emProc.chopAndAssign(1);
    emitRandom = emProc.chopAndAssign(1);
    emissionRate = emProc.chopAndAssign(4);
    emitStart = emProc.chopAndAssign(2);
    emitEnd = emProc.chopAndAssign(2);
    emitInterval = emProc.chopAndAssign(2);
    inheritParticleTranslation = emProc.chopAndAssign(1);
    inheritChildEmmitterTransformation = emProc.chopAndAssign(1);
    debugPrint("we are now parsing our emitterDims (offset should be 1c)");
    debugPrint("our offset is, ${emProc.hexPosition()}");
    emitterDim1 = emProc.chopAndAssign(4);
    debugPrint("Our first emitterDim1 is ${emitterDim1}");
    emitterDim2 = emProc.chopAndAssign(4);
    emitterDim3 = emProc.chopAndAssign(4);
    emitterDim4 = emProc.chopAndAssign(4);
    emitterDim5 = emProc.chopAndAssign(4);
    emitterDim6 = emProc.chopAndAssign(4);
    emitDiversion = emProc.chopAndAssign(2);
    randomVel = emProc.chopAndAssign(1);
    randomMoment = emProc.chopAndAssign(1);
    powerRadiation = emProc.chopAndAssign(4);
    powerYAxisVal = emProc.chopAndAssign(4);
    debugPrint("after powerYAxisVal. Hex: ${emProc.hexPosition()}");
    powerRandom = emProc.chopAndAssign(4);
    powerNormal = emProc.chopAndAssign(4);
    diffEmitNormal = emProc.chopAndAssign(4);
    powerSpec = emProc.chopAndAssign(4);
    diffSpec = emProc.chopAndAssign(4);
    debugPrint("after diffSpec. Hex: ${emProc.hexPosition()}");
    emAngle = emProc.chopAndAssign(12);
    scale = emProc.chopAndAssign(12);
    rot = emProc.chopAndAssign(12);
    debugPrint("after rot, offset should start at 78");
    debugPrint("our offset is, ${emProc.hexPosition()}");
    transl = emProc.chopAndAssign(12);
    LODNearest = emProc.chopAndAssign(1);
    LODFurthest = emProc.chopAndAssign(1);
    LODMinEm = emProc.chopAndAssign(1);
    LODAlpha = emProc.chopAndAssign(1);
    randSeed = emProc.chopAndAssign(4);
    unknown0 = emProc.chopAndAssign(8);
    drawFlagsBitfield = emProc.chopAndAssign(2);
    alphaComp0 = emProc.chopAndAssign(1);
    alphaComp1 = emProc.chopAndAssign(1);
    alphaCompOperation = emProc.chopAndAssign(1);
    numTEVStages = emProc.chopAndAssign(1);
    unknown1 = emProc.chopAndAssign(1);
    indTEVEnabled = emProc.chopAndAssign(1);
    textureUsedTEV = emProc.chopAndAssign(4);
    debugPrint("midst processing subfile data again");
    TEVColInputSourcesA = emProc.chopAndAssign(4);
    TEVColInputSourcesB = emProc.chopAndAssign(4);
    TEVColInputSourcesC = emProc.chopAndAssign(4);
    TEVColInputSourcesD = emProc.chopAndAssign(4);
    TEV1Operation = emProc.chopAndAssign(1);
    TEV1Bias = emProc.chopAndAssign(1);
    TEV1Scale = emProc.chopAndAssign(1);
    TEV1Clamp = emProc.chopAndAssign(1);
    TEV1OutRegister = emProc.chopAndAssign(1);
    TEV2Operation = emProc.chopAndAssign(1);
    TEV2Bias = emProc.chopAndAssign(1);
    TEV2Scale = emProc.chopAndAssign(1);
    TEV2Clamp = emProc.chopAndAssign(1);
    TEV2OutRegister = emProc.chopAndAssign(1);
    TEV3Operation = emProc.chopAndAssign(1);
    TEV3Bias = emProc.chopAndAssign(1);
    TEV3Scale = emProc.chopAndAssign(1);
    TEV3Clamp = emProc.chopAndAssign(1);
    TEV3OutRegister = emProc.chopAndAssign(1);
    TEV4Operation = emProc.chopAndAssign(1);
    TEV4Bias = emProc.chopAndAssign(1);
    TEV4Scale = emProc.chopAndAssign(1);
    TEV4Clamp = emProc.chopAndAssign(1);
    TEV4OutRegister = emProc.chopAndAssign(1);
    debugPrint("midst processing subfile data again2");
    TEV1AlphaInput = emProc.chopAndAssign(4);
    TEV2AlphaInput = emProc.chopAndAssign(4);
    TEV3AlphaInput = emProc.chopAndAssign(4);
    TEV4AlphaInput = emProc.chopAndAssign(4);
    debugPrint("midst processing subfile data again3");
    alphaTEV1Operations = emProc.chopAndAssign(1);
    alphaTEV1Bias = emProc.chopAndAssign(1);
    alphaTEV1Scale = emProc.chopAndAssign(1);
    alphaTEV1Clamp = emProc.chopAndAssign(1);
    alphaTEV1OutRegister = emProc.chopAndAssign(1);
    alphaTEV2Operations = emProc.chopAndAssign(1);
    alphaTEV2Bias = emProc.chopAndAssign(1);
    alphaTEV2Scale = emProc.chopAndAssign(1);
    alphaTEV2Clamp = emProc.chopAndAssign(1);
    alphaTEV2OutRegister = emProc.chopAndAssign(1);
    alphaTEV3Operations = emProc.chopAndAssign(1);
    alphaTEV3Bias = emProc.chopAndAssign(1);
    alphaTEV3Scale = emProc.chopAndAssign(1);
    alphaTEV3Clamp = emProc.chopAndAssign(1);
    alphaTEV3OutRegister = emProc.chopAndAssign(1);
    alphaTEV4Operations = emProc.chopAndAssign(1);
    alphaTEV4Bias = emProc.chopAndAssign(1);
    alphaTEV4Scale = emProc.chopAndAssign(1);
    alphaTEV4Clamp = emProc.chopAndAssign(1);
    alphaTEV4OutRegister = emProc.chopAndAssign(1);
    debugPrint("midst processing subfile data again4");
    constColSelectors = emProc.chopAndAssign(4);
    constAlphaSelectors = emProc.chopAndAssign(4);
    blendModeType = emProc.chopAndAssign(1);
    blendSourceFactor = emProc.chopAndAssign(1);
    blendDestFactor = emProc.chopAndAssign(1);
    blendOperation = emProc.chopAndAssign(1);
    assignPartColTEVColRegisters = emProc.chopAndAssign(8);
    assignPartAlphTEVAlphRegisters = emProc.chopAndAssign(8);
    debugPrint("after PartAlphTEV Alph Registers");
    debugPrint("our offset is, ${emProc.hexPosition()}");
    ZCompFunct = emProc.chopAndAssign(1);
    alphFlickType = emProc.chopAndAssign(1);
    alphFlickCycleLen = emProc.chopAndAssign(2);
    alphFlickMaxCycleRandDev = emProc.chopAndAssign(1);
    alphFlickAmpl = emProc.chopAndAssign(1);
    lightingMode = emProc.chopAndAssign(1);
    lightingType = emProc.chopAndAssign(1);
    lightingAmbCol = emProc.chopAndAssign(4);
    lightDiffCol = emProc.chopAndAssign(4);
    debugPrint("lightRadius hex ${emProc.hexPosition()}");
    lightRadius = emProc.chopAndAssign(4);
    debugPrint("lightRadius = ${lightRadius}");
    lightPosX = emProc.chopAndAssign(4);
    lightPosY = emProc.chopAndAssign(4);
    lightPosZ = emProc.chopAndAssign(4);
    indTexMat1 = emProc.chopAndAssign(4);
    indTexMat2 = emProc.chopAndAssign(4);
    debugPrint("our hex is ${emProc.hexPosition()}");
    debugPrint("our indTexMat2 is $indTexMat2");
    indTexMat3 = emProc.chopAndAssign(4);
    indTexMat4 = emProc.chopAndAssign(4);
    indTexMat5 = emProc.chopAndAssign(4);
    indTexMat6 = emProc.chopAndAssign(4);
    debugPrint("hex is ${emProc.hexPosition()}");
    indTexMatScale = emProc.chopAndAssign(1);
    pivotX = emProc.chopAndAssign(1);
    debugPrint("pivotX is ${pivotX}");
    pivotY = emProc.chopAndAssign(1);
    padding0 = emProc.chopAndAssign(1);
    particleType = emProc.chopAndAssign(1);
    debugPrint("hex is ${emProc.hexPosition()}");
    particleTypeOpt = emProc.chopAndAssign(1);
    debugPrint("particleTypeOpt is ${particleTypeOpt}");
    movementType = emProc.chopAndAssign(1);
    rotAxis = emProc.chopAndAssign(1);
    gabiHelp0 = emProc.chopAndAssign(1);
    gabiHelp1 = emProc.chopAndAssign(1);
    gabiHelp2 = emProc.chopAndAssign(1);
    padding1 = emProc.chopAndAssign(1);
    debugPrint("our offset is, ${emProc.hexPosition()}");
    zOffset = emProc.chopAndAssign(4);
    debugPrint("our zOffset is $zOffset");
    debugPrint("end of subfile em data");
    debugPrint(emProc.dat);

    // particle data
    DataProcessor partProc = DataProcessor(partAndAnimData, 0);
    debugPrint("our partProc and Anim dat is ${partProc.dat}");
    debugPrint("our offset is, ${partProc.hexPosition()}");
    lenParticleDat = partProc.chopAndAssign(4);
    debugPrint("our lenParticleDat is, ${lenParticleDat}");
    col1Primary = partProc.chopAndAssign(4);
    debugPrint("our col1Primary is, ${col1Primary}");
    col1Secondary = partProc.chopAndAssign(4);
    debugPrint("our col1Secondary is, ${col1Secondary}");
    col2Primary = partProc.chopAndAssign(4);
    debugPrint("our col2Primary is, ${col2Primary}");
    col2Secondary = partProc.chopAndAssign(4);
    debugPrint("our col2Secondary is, ${col2Secondary}");
    sizePart = partProc.chopAndAssign(8);
    debugPrint("our sizePart is, ${sizePart}");
    scalePart = partProc.chopAndAssign(8);
    debugPrint("our scalePart is, ${scalePart}");
    rotPart = partProc.chopAndAssign(12);
    debugPrint("our rotPart is, ${rotPart}");
    texScale1 = partProc.chopAndAssign(8);
    debugPrint("our texScale1 is, ${texScale1}");
    texScale2 = partProc.chopAndAssign(8);
    debugPrint("our texScale2 is, ${texScale2}");
    texScale3 = partProc.chopAndAssign(8);
    debugPrint("our texScale3 is, ${texScale3}");
    texRot = partProc.chopAndAssign(12);
    debugPrint("our texRot is, ${texRot}");
    texTrans1 = partProc.chopAndAssign(8);
    debugPrint("our texTrans1 is, ${texTrans1}");
    texTrans2 = partProc.chopAndAssign(8);
    debugPrint("our texTrans2 is, ${texTrans2}");
    texTrans3 = partProc.chopAndAssign(8);
    debugPrint("our texTrans3 is, ${texTrans3}");
    debugPrint("our offset is, ${partProc.hexPosition()}");
    mTexture1 = partProc.chopAndAssign(4);
    debugPrint("our mTexture1 is, ${mTexture1}");
    mTexture2 = partProc.chopAndAssign(4);
    debugPrint("our mTexture2 is, ${mTexture2}");
    mTexture3 = partProc.chopAndAssign(4);
    debugPrint("our mTexture3 is, ${mTexture3}");
    textureWrap = partProc.chopAndAssign(2);
    debugPrint("our texWrap is, ${textureWrap}");
    textureReverse = partProc.chopAndAssign(1);
    debugPrint("our textureReverse is, ${textureReverse}");
    alphaCompRef0 = partProc.chopAndAssign(1);
    debugPrint("our alphaCompRef0 is, ${alphaComp0}");
    debugPrint("our offset is, ${partProc.hexPosition()}");
    alphaCompRef1 = partProc.chopAndAssign(1);
    debugPrint("our alphaCompRef1 is, ${alphaComp1}");
    rotOffsetRand1 = partProc.chopAndAssign(1);
    debugPrint("our rotOffsetRand1 is, ${rotOffsetRand1}");
    rotOffsetRand2 = partProc.chopAndAssign(1);
    debugPrint("our rotOffsetRand2 is, ${rotOffsetRand2}");
    rotOffsetRand3 = partProc.chopAndAssign(1);
    debugPrint("our rotOffsetRand3 is, ${rotOffsetRand3}");
    rotOffset = partProc.chopAndAssign(12);
    debugPrint("our rotOffset is $rotOffset");
    debugPrint("subfile_data particle data, before variable texture lengths");
    debugPrint("our partProc dat is ${partProc.dat}");
    lenTexRef1 = partProc.chopAndAssign(2);
    debugPrint("out lenTexRef1 is $lenTexRef1");
    texRef1 = partProc.chopAndAssign(int.parse(lenTexRef1, radix: 16));
    lenTexRef2 = partProc.chopAndAssign(2);
    texRef2 = partProc.chopAndAssign(int.parse(lenTexRef2, radix: 16));
    lenTexRef3 = partProc.chopAndAssign(2);
    texRef3 = partProc.chopAndAssign(int.parse(lenTexRef1, radix: 16));
    debugPrint("read in subfile_data");
    // Spacing and animationData combined together
    // bad practice, but maybe can get away with it
    animationData = partProc.dat; // no getter needed get rekt java
    // any animation stuff here
    debugPrint("and animation data is $animationData");
  }

  String getOtherBytes() {
    return otherBytes;
  }
}
