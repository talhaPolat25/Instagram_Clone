//
//  CameraViewController.swift
//  Instagram_Clone
//
//  Created by talha polat on 25.11.2023.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    @IBOutlet weak var btnTakePhoto: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        takePhoto()
        btnTakePhoto.imageView?.contentMode = .scaleAspectFill
        self.transitioningDelegate = self
    }
    var animatedPresentation = AnimatedPresantation()
    let animatedDismissPresantation = AnimatedDismissPresentation()
    override var prefersStatusBarHidden: Bool{
        return true
    }
    let output = AVCapturePhotoOutput()
    fileprivate func takePhoto(){
        let captureSession = AVCaptureSession()
        
        guard let device = AVCaptureDevice.default(for: .video) else {return}
        
        do{
            let input = try AVCaptureDeviceInput(device: device)
            
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
            }
        }catch let error{
            print("It couldnt add the input to session: ",error.localizedDescription)
        }
        
        
        if captureSession.canAddOutput(output){
            captureSession.addOutput(output)
        }
        
        let preview = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(preview)
        preview.frame = view.bounds
        
        DispatchQueue.global(qos: .background).async {
            captureSession.startRunning()
        }
        view.layer.insertSublayer(btnTakePhoto.layer, above: preview)
        view.layer.insertSublayer(btnBack.layer, above: preview)
        
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func btnTakePhotoClicked(_ sender: UIButton) {
        let capturePhotoSettings = AVCapturePhotoSettings()
        output.capturePhoto(with: capturePhotoSettings, delegate: self)
    }
    /*
    // MARK: - Navigation

     @IBAction func btnBackClicked(_ sender: UIButton) {
     }
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CameraViewController:AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let photoData = photo.fileDataRepresentation() else{return}
       
        let capturedPhoto = UIImage(data: photoData)
        let imgView = PhotoPreviewView()
        imgView.imgView.image = capturedPhoto
        view.addSubview(imgView)
        imgView.frame = view.frame
    }
}
extension CameraViewController:UIViewControllerTransitioningDelegate{
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animatedPresentation
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animatedDismissPresantation
    }
}
