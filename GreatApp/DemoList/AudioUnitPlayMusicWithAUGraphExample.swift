//
//  AudioUnitPlayMusicWithAUGraphExample.swift
//  GreatApp
//
//  Created by 赵福成 on 2019/5/5.
//  Copyright © 2019 zhaofucheng. All rights reserved.
//

import UIKit
import AVFoundation

class AudioUnitPlayMusicWithAUGraphExample: UIViewController {

    var playerGraph: AUGraph!
    var playerIONode: AUNode = 0
    var playerNode: AUNode = 0
    var playerIOUnit: AudioUnit?
    var playerUnit: AudioUnit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.width, height: 40))
        label.text = "心如止水"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.center = view.center
        view.addSubview(label)
        
        setupAudioSession()
        setupPlayGraph()
        play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stop()
    }

    @discardableResult
    func play() -> Bool {
        AUGraphStart(playerGraph)
        return true
    }
    
    func stop() {
        var isRunning: DarwinBoolean = false
        AUGraphIsRunning(playerGraph, &isRunning)
        if isRunning.boolValue {
            AUGraphStop(playerGraph)
        }
    }
    
    func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord)
            try audioSession.setPreferredSampleRate(44100)
            try audioSession.overrideOutputAudioPort(.speaker)
            try audioSession.setActive(true, options: [])
        } catch {
            
        }
    }
    
    func setupPlayGraph() {
        
        var status: OSStatus = noErr
        status = NewAUGraph(&playerGraph)
        CheckError(status, "创建AUGraph错误")
        
        var ioDesc = AudioComponentDescription(componentType: kAudioUnitType_Output,
                                               componentSubType: kAudioUnitSubType_RemoteIO,
                                               componentManufacturer: kAudioUnitManufacturer_Apple,
                                               componentFlags: 0, componentFlagsMask: 0)
        status = AUGraphAddNode(playerGraph, &ioDesc, &playerIONode)
        CheckError(status, "创建I/O Node错误")
        
        var playerDesc = AudioComponentDescription(componentType: kAudioUnitType_Generator,
                                                   componentSubType: kAudioUnitSubType_AudioFilePlayer,
                                                   componentManufacturer: kAudioUnitManufacturer_Apple,
                                                   componentFlags: 0, componentFlagsMask: 0)
        status = AUGraphAddNode(playerGraph, &playerDesc, &playerNode)
        CheckError(status, "创建Player Node错误")
        
        status = AUGraphOpen(playerGraph)
        CheckError(status, "打开AUGraph错误")
        
        status = AUGraphNodeInfo(playerGraph, playerIONode, nil, &playerIOUnit)
        CheckError(status, "取出I/O Unit错误")
        
        status = AUGraphNodeInfo(playerGraph, playerNode, nil, &playerUnit)
        CheckError(status, "取出Player Unit错误")
        
        let bytesPerSample: UInt32 = UInt32(MemoryLayout<UInt32>.size)
        var streamFormat = AudioStreamBasicDescription(mSampleRate: 44100,
                                    mFormatID: kAudioFormatLinearPCM,
                                    mFormatFlags: kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved,
                                    mBytesPerPacket: bytesPerSample,
                                    mFramesPerPacket: 1, mBytesPerFrame: bytesPerSample, mChannelsPerFrame: 2, mBitsPerChannel: 8 * bytesPerSample,
                                    mReserved: 0)
        guard let playerIOUnit = playerIOUnit else { return }
        status = AudioUnitSetProperty(playerIOUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 1, &streamFormat, UInt32(MemoryLayout.size(ofValue: streamFormat)))
        CheckError(status, "设置playerIOUnit的Element1的格式错误")
        
        guard let playerUnit = playerUnit else { return }
        AudioUnitSetProperty(playerUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 0, &streamFormat, UInt32(MemoryLayout.size(ofValue: streamFormat)))
        CheckError(status, "设置playerUnit的Element0的格式错误")
        
        
        status = AUGraphConnectNodeInput(playerGraph, playerNode, 0, playerIONode, 0)
        CheckError(status, "连接Player Node错误")
        
        status = AUGraphInitialize(playerGraph)
        CheckError(status, "初始化AUGraph错误")
        
        setupFilePlayer()
    }
    
    func setupFilePlayer() {
        var status = noErr
        var musicFile = AudioFileID(bitPattern: MemoryLayout<AudioFileID>.size)
        let musicUrl = Bundle.main.url(forResource: "C400003ebMYY2PGmn6", withExtension: "mp4")!
        AudioFileOpenURL(musicUrl as CFURL, .readPermission, 0, &musicFile)
        CheckError(status, "打开音乐文件错误")
        
        guard let playerUnit = playerUnit else { return }
        AudioUnitSetProperty(playerUnit, kAudioUnitProperty_ScheduledFileIDs, kAudioUnitScope_Global, 0, &musicFile, UInt32(MemoryLayout.size(ofValue: musicFile)))
        CheckError(status, "设置文件路径错误")
        
        var fileStreamDesc = AudioStreamBasicDescription()
        var size: UInt32 = UInt32(MemoryLayout.size(ofValue: fileStreamDesc))
        guard let lmusicFile = musicFile else { return }
        status = AudioFileGetProperty(lmusicFile, kAudioFilePropertyDataFormat, &size, &fileStreamDesc)
        
        var packets: UInt64 = 0
        var propsize: UInt32 = UInt32(MemoryLayout<UInt64>.size)
        AudioFileGetProperty(lmusicFile, kAudioFilePropertyAudioDataPacketCount, &propsize, &packets)
        
        var fileRegion = ScheduledAudioFileRegion(mTimeStamp: AudioTimeStamp(mSampleTime: 0, mHostTime: 0,
                                                                             mRateScalar: 0, mWordClockTime: 0,
                                                                             mSMPTETime: SMPTETime(),
                                                                             mFlags: .sampleTimeValid,
                                                                             mReserved: 0),
                                                  mCompletionProc: nil,
                                                  mCompletionProcUserData: nil,
                                                  mAudioFile: lmusicFile, mLoopCount: 0,
                                                  mStartFrame: 0, mFramesToPlay: UInt32(packets) * fileStreamDesc.mFramesPerPacket)
        
        status = AudioUnitSetProperty(playerUnit, kAudioUnitProperty_ScheduledFileRegion, kAudioUnitScope_Global, 0, &fileRegion, UInt32(MemoryLayout.size(ofValue: fileRegion)))
        
        var defaultVal: UInt32 = 0
        status = AudioUnitSetProperty(playerUnit, kAudioUnitProperty_ScheduledFilePrime, kAudioUnitScope_Global, 0, &defaultVal, UInt32(MemoryLayout.size(ofValue: defaultVal)))
        
        var startTime = AudioTimeStamp()
        startTime.mFlags = .sampleTimeValid
        startTime.mSampleTime = -1
        status = AudioUnitSetProperty(playerUnit, kAudioUnitProperty_ScheduleStartTimeStamp, kAudioUnitScope_Global, 0, &startTime, UInt32(MemoryLayout.size(ofValue: startTime)))
    }
    
    
    func CheckError(_ error: OSStatus, _ operation: String) -> Void
    {
        if (error == noErr) { return }
        
        let count = 5
        let stride = MemoryLayout<OSStatus>.stride
        let byteCount = stride * count
        
        var error_ =  CFSwapInt32HostToBig(UInt32(error))
        var charArray: [CChar] = [CChar](repeating: 0, count: byteCount )
        withUnsafeBytes(of: &error_) { (buffer: UnsafeRawBufferPointer) in
            for (index, byte) in buffer.enumerated() {
                charArray[index + 1] = CChar(byte)
            }
        }
        
        let v1 = charArray[1], v2 = charArray[2], v3 = charArray[3], v4 = charArray[4]
        
        if (isprint(Int32(v1)) > 0 && isprint(Int32(v2)) > 0 && isprint(Int32(v3)) > 0 && isprint(Int32(v4)) > 0) {
            charArray[0] = "\'".utf8CString[0]
            charArray[5] = "\'".utf8CString[0]
            let errStr = NSString(bytes: &charArray, length: charArray.count, encoding: String.Encoding.ascii.rawValue)
            print("Error: \(operation) (\(errStr!))")
        }
        else {
            print("Error: \(error)")
        }
    }
}
