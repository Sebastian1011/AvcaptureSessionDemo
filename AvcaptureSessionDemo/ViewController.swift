//
//  ViewController.swift
//  AvcaptureSessionDemo
//
//  Created by 张子名 on 12/28/15.
//  Copyright © 2015 lenmontech. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var error: NSError?
    var captureDevice : AVCaptureDevice?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)

        
        for device in devices{
            if device.position == AVCaptureDevicePosition.Front{
                captureDevice = device as? AVCaptureDevice
                if captureDevice != nil {
                    print("capture device found")
                    beginSession()
                }
            }
        }
        

    }
    
    func beginSession(){
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            captureSession.sessionPreset = AVCaptureSessionPresetPhoto
            captureSession.startRunning()
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
                previewLayer.bounds = CGRectMake(0.0, 0.0, view.bounds.size.width/2, view.bounds.size.height/2)
                previewLayer.position = CGPointMake(view.bounds.midX, view.bounds.midY)
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                let cameraPreview = UIView(frame: CGRectMake(0.0, 0.0, view.bounds.size.width/2, view.bounds.size.height/2))
                cameraPreview.layer.addSublayer(previewLayer)
                cameraPreview.addGestureRecognizer(UITapGestureRecognizer(target: self, action:"saveToCamera:"))
                view.addSubview(cameraPreview)
            }
        }catch{
            print(error)
            return
            
            
        }

    }
    
    @IBAction func VedioButton(sender: AnyObject) {
        
        
    }

    func saveToCamera(sender: UITapGestureRecognizer) {
        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

