//
//  AudioUnitPlayMusicExample.swift
//  GreatApp
//
//  Created by 赵福成 on 2019/5/4.
//  Copyright © 2019 zhaofucheng. All rights reserved.
//

import UIKit
import AVFoundation

class AudioUnitPlayMusicExample: UIViewController {

    var audioFile: ExtAudioFileRef?
    var fileDesc: AudioStreamBasicDescription?
    var packetSize: UInt32 = 0
    var audioUnit: AudioUnit?
    var repeatPlay: Bool = true
    var playing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.width, height: 40))
        label.text = "依兰爱情故事"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.center = view.center
        view.addSubview(label)
        
        setupAudioSession()
        setupPlayFile()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stop()
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
    
    func setupPlayFile() {
        if let audioFile = audioFile {
            ExtAudioFileDispose(audioFile)
            self.audioFile = nil
        }
        let musicUrl = Bundle.main.url(forResource: "C400003LA9Mi3gUHcK", withExtension: "mp4")!
        var status = ExtAudioFileOpenURL(musicUrl as CFURL, &audioFile)
        CheckError(status, "打开音频文件\(musicUrl)")
        guard let audioFile = audioFile else { return }
        var size: UInt32 = UInt32(MemoryLayout<AudioStreamBasicDescription>.size)
        status = ExtAudioFileGetProperty(audioFile, kExtAudioFileProperty_FileDataFormat, &size, &fileDesc)
        CheckError(status, "读取文件格式")
        
        let bytesPerSample: UInt32 = UInt32(MemoryLayout<Float32>.size)
        var clientDesc = AudioStreamBasicDescription(mSampleRate: fileDesc?.mSampleRate ?? 44100,
                                    mFormatID: kAudioFormatLinearPCM,
                                    mFormatFlags: kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved,
                                    mBytesPerPacket: bytesPerSample,
                                    mFramesPerPacket: 1,
                                    mBytesPerFrame: bytesPerSample,
                                    mChannelsPerFrame: 2,
                                    mBitsPerChannel: 8 * bytesPerSample,
                                    mReserved: 0)
        size = UInt32(MemoryLayout.size(ofValue: clientDesc))
        status = ExtAudioFileSetProperty(audioFile, kExtAudioFileProperty_ClientDataFormat, size, &clientDesc)
        CheckError(status, "设置文件格式")
        
        size = UInt32(MemoryLayout<UInt32>.size)
        ExtAudioFileGetProperty(audioFile, kExtAudioFileProperty_ClientMaxPacketSize, &size, &packetSize);
        
        setupAudioUnit(audioDesc: clientDesc)
    }
    
    func setupAudioUnit(audioDesc: AudioStreamBasicDescription) {
        var varAudioDesc = audioDesc
        var componentDesc = AudioComponentDescription(componentType: kAudioUnitType_Output,
                                  componentSubType: kAudioUnitSubType_RemoteIO,
                                  componentManufacturer: kAudioUnitManufacturer_Apple,
                                  componentFlags: 0,
                                  componentFlagsMask: 0)
        guard let component = AudioComponentFindNext(nil, &componentDesc) else { return }
        var status = AudioComponentInstanceNew(component, &audioUnit)
        
        guard let audioUnit = audioUnit else { return }
        
        CheckError(status, "创建AudioUnit")
        let busZero: UInt32 = 0
        var oneFlag: UInt32 = 1
        status = AudioUnitSetProperty(audioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Output, busZero, &oneFlag, UInt32(MemoryLayout<UInt32>.size))
        CheckError(status, "连接扬声器")
        
        status = AudioUnitSetProperty(audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, busZero, &varAudioDesc, UInt32(MemoryLayout.size(ofValue: varAudioDesc)))
        CheckError(status, "设置输入格式")
        
        var callbackStruct = AURenderCallbackStruct(inputProc: { (inRefCon, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, ioData) -> OSStatus in
            let cls:AudioUnitPlayMusicExample = Unmanaged<AudioUnitPlayMusicExample>.fromOpaque(inRefCon).takeUnretainedValue()
            var framesPerPacket = inNumberFrames
            return cls.readFrame(frameNum: &framesPerPacket, bufferList: ioData)
        }, inputProcRefCon: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
        status = AudioUnitSetProperty(audioUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Group, busZero, &callbackStruct, UInt32(MemoryLayout.size(ofValue: callbackStruct)))
        status = AudioOutputUnitStart(audioUnit)
    }
    
    func readFrame(frameNum: UnsafeMutablePointer<UInt32>, bufferList: UnsafeMutablePointer<AudioBufferList>?) -> OSStatus {
        guard let audioFile = audioFile else {
            frameNum.pointee = 0
            return -1
        }
        guard let bufferList = bufferList else { return -1 }
        let inputFrameNum = frameNum.pointee
        var status = ExtAudioFileRead(audioFile, frameNum, bufferList)
        if frameNum.pointee <= 0 {
            if repeatPlay {
                frameNum.pointee = inputFrameNum
                ExtAudioFileSeek(audioFile, 0)
                status = ExtAudioFileRead(audioFile, frameNum, bufferList)
            } else {
                memset(bufferList.pointee.mBuffers.mData, 0, Int(bufferList.pointee.mBuffers.mDataByteSize))
                stop()
            }
        }
        
        return status
    }
    
    func stop() {
        if let audioFile = audioFile {
            ExtAudioFileDispose(audioFile)
            self.audioFile = nil
        }
        
        if let audioUnit = audioUnit {
            AudioOutputUnitStop(audioUnit)
            AudioComponentInstanceDispose(audioUnit)
            self.audioUnit = nil
        }
        playing = false
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
