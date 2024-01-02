import 'package:flutter/material.dart';

class DataProcessor {
  String emData;

  DataProcessor(this.emData);

  String chopAndAssign(int length) {
    var result = emData.substring(0, length);
    emData = emData.substring(length, emData.length);
    return result;
  }
}

class SubFileData extends ChangeNotifier {
  List<String> splitAtExcl(String str, int index) {
    return [str.substring(0, index), str.substring(index, str.length)];
  }

  String first(String str, int index) {
    return str.substring(0, index);
  }

  String chop(String str, int index) {
    return str.substring(index, str.length);
  }

  int offset;
  int lenDataBytes;
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
  late String emitterDims;
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
  late String TEVColInputSources;
  late String TEVOperations;
  late String alphaInputTEV;
  late String alphaTEVOperations;
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
  late String lightPos;
  late String indTexMat;
  late String indTexScale; //sbyte
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
      {required this.bytes, required this.offset, required this.lenDataBytes}) {
    String thisBytes = splitAtExcl(bytes, lenDataBytes)[0];
    otherBytes = splitAtExcl(thisBytes, lenDataBytes)[1];
    String emSize = thisBytes.substring(4, 8);
    int emSizeInt = int.parse(emSize, radix: 16);
    String emData =
        thisBytes.substring(8, emSizeInt); // the first header is already read
    String partAndAnimData = splitAtExcl(thisBytes, emSizeInt)[1];

    parseThis(emData, partAndAnimData);
  }

  String getStr() {
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
    out.write(emitterDims);
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
    out.write(TEVColInputSources);
    out.write(TEVOperations);
    out.write(alphaInputTEV);
    out.write(alphaTEVOperations);
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
    out.write(lightPos);
    out.write(indTexMat);
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
    out.write(lenParticleDat);
    out.write(partBytes);
    out.write(col1Primary);
    out.write(col1Secondary);
    out.write(col2Primary);
    out.write(col2Secondary);
    out.write(sizePart);
    out.write(scalePart);
    out.write(rotPart);
    out.write(texScale1);
    out.write(texScale2);
    out.write(texScale3);
    out.write(texRot);
    out.write(texTrans1);
    out.write(texTrans2);
    out.write(texTrans3);
    out.write(mTexture1);
    out.write(mTexture2);
    out.write(mTexture3);
    out.write(textureWrap);
    out.write(textureReverse);
    out.write(alphaCompRef0);
    out.write(alphaCompRef1);
    out.write(rotOffsetRand1);
    out.write(rotOffsetRand2);
    out.write(rotOffsetRand3);
    out.write(rotOffset);
    out.write(lenTexRef1);
    out.write(texRef1);
    out.write(lenTexRef2);
    out.write(texRef2);
    out.write(lenTexRef3);
    out.write(texRef3);
    out.write(animationData);
    return out.toString();
  }

  void parseThis(emData, partAndAnimData) {
    DataProcessor emProc = DataProcessor(emData);
    unknown0 = emProc.chopAndAssign(4);
    emitFlags = emProc.chopAndAssign(3);
    emitterShape = emProc.chopAndAssign(1);
    emitterLife = emProc.chopAndAssign(2);
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
    emitterDims = emProc.chopAndAssign(18);
    emitDiversion = emProc.chopAndAssign(2);
    randomVel = emProc.chopAndAssign(1);
    randomMoment = emProc.chopAndAssign(1);
    randomMoment = emProc.chopAndAssign(4);
    powerRadiation = emProc.chopAndAssign(4);
    powerYAxisVal = emProc.chopAndAssign(4);
    powerRandom = emProc.chopAndAssign(4);
    powerNormal = emProc.chopAndAssign(4);
    diffEmitNormal = emProc.chopAndAssign(4);
    powerSpec = emProc.chopAndAssign(4);
    diffSpec = emProc.chopAndAssign(4);
    emAngle = emProc.chopAndAssign(4);
    scale = emProc.chopAndAssign(12);
    rot = emProc.chopAndAssign(12);
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
    TEVColInputSources = emProc.chopAndAssign(16);
    TEVOperations = emProc.chopAndAssign(20);
    alphaInputTEV = emProc.chopAndAssign(16);
    alphaTEVOperations = emProc.chopAndAssign(20);
    constColSelectors = emProc.chopAndAssign(4);
    constAlphaSelectors = emProc.chopAndAssign(4);
    blendModeType = emProc.chopAndAssign(1);
    blendSourceFactor = emProc.chopAndAssign(1);
    blendDestFactor = emProc.chopAndAssign(1);
    blendOperation = emProc.chopAndAssign(1);
    assignPartColTEVColRegisters = emProc.chopAndAssign(8);
    assignPartAlphTEVAlphRegisters = emProc.chopAndAssign(8);
    ZCompFunct = emProc.chopAndAssign(1);
    alphFlickType = emProc.chopAndAssign(1);
    alphFlickCycleLen = emProc.chopAndAssign(2);
    alphFlickMaxCycleRandDev = emProc.chopAndAssign(1);
    alphFlickAmpl = emProc.chopAndAssign(1);
    lightingMode = emProc.chopAndAssign(1);
    lightingType = emProc.chopAndAssign(1);
    lightingAmbCol = emProc.chopAndAssign(4);
    lightDiffCol = emProc.chopAndAssign(4);
    lightRadius = emProc.chopAndAssign(4);
    lightPos = emProc.chopAndAssign(12);
    indTexMat = emProc.chopAndAssign(24);
    pivotX = emProc.chopAndAssign(1);
    pivotY = emProc.chopAndAssign(1);
    padding0 = emProc.chopAndAssign(1);
    particleType = emProc.chopAndAssign(1);
    particleTypeOpt = emProc.chopAndAssign(1);
    movementType = emProc.chopAndAssign(1);
    rotAxis = emProc.chopAndAssign(1);
    gabiHelp0 = emProc.chopAndAssign(1);
    gabiHelp1 = emProc.chopAndAssign(1);
    gabiHelp2 = emProc.chopAndAssign(1);
    padding1 = emProc.chopAndAssign(1);
    zOffset = emProc.chopAndAssign(4);

    // particle data
    DataProcessor partProc = DataProcessor(partAndAnimData);
    lenParticleDat = partProc.chopAndAssign(4);
    partBytes = partProc.chopAndAssign(4);
    col1Primary = partProc.chopAndAssign(4);
    col1Secondary = partProc.chopAndAssign(4);
    col2Primary = partProc.chopAndAssign(4);
    col2Secondary = partProc.chopAndAssign(4);
    sizePart = partProc.chopAndAssign(8);
    scalePart = partProc.chopAndAssign(8);
    rotPart = partProc.chopAndAssign(12);
    texScale1 = partProc.chopAndAssign(8);
    texScale2 = partProc.chopAndAssign(8);
    texScale3 = partProc.chopAndAssign(8);
    texRot = partProc.chopAndAssign(12);
    texTrans1 = partProc.chopAndAssign(8);
    texTrans2 = partProc.chopAndAssign(8);
    texTrans3 = partProc.chopAndAssign(8);
    mTexture1 = partProc.chopAndAssign(4);
    mTexture2 = partProc.chopAndAssign(4);
    mTexture3 = partProc.chopAndAssign(4);
    textureWrap = partProc.chopAndAssign(2);
    textureReverse = partProc.chopAndAssign(1);
    alphaCompRef0 = partProc.chopAndAssign(1);
    alphaCompRef1 = partProc.chopAndAssign(1);
    rotOffsetRand1 = partProc.chopAndAssign(1);
    rotOffsetRand2 = partProc.chopAndAssign(1);
    rotOffsetRand3 = partProc.chopAndAssign(1);
    rotOffset = partProc.chopAndAssign(12);
    lenTexRef1 = partProc.chopAndAssign(2);
    texRef1 = partProc.chopAndAssign(int.parse(lenTexRef1, radix: 16));
    lenTexRef2 = partProc.chopAndAssign(2);
    texRef2 = partProc.chopAndAssign(int.parse(lenTexRef2, radix: 16));
    lenTexRef3 = partProc.chopAndAssign(2);
    texRef3 = partProc.chopAndAssign(int.parse(lenTexRef1, radix: 16));
    animationData = partProc.chopAndAssign(partAndAnimData.length);
  }

  String getOtherBytes() {
    return otherBytes;
  }
}
