//
//  QRCodeGenerator.swift
//  Pods
//
//  Created by Nick DiStefano on 12/23/15.
//
//

import Foundation

public extension String {
    public func qrImage(inputCorrection: String = "Q") -> CIImage? {
        let data = self.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue(inputCorrection, forKey: "inputCorrectionLevel")
        
        return filter?.outputImage
    }

    /// 7.00 is default Min is 0 Max is 20
    public func barcode128(inputQuietSpace: NSNumber = 7.00) -> CIImage? {
        let data = self.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue(inputQuietSpace, forKey: "inputQuietSpace")
        
        return filter?.outputImage
    }
}

public extension UIImage {
    static func createFromCIImage(_ ciImage: CIImage?, foregroundColor: UIColor, backgroundColor: UIColor, size: CGSize) -> UIImage? {
        return ciImage?.scale(size)?.color(foregroundColor: foregroundColor, backgroundColor: backgroundColor)?.mapToUIImage()
    }
}

public extension CIImage {
    public func mapToUIImage() -> UIImage? {
        return UIImage(ciImage: self)
    }
    
    public func scale(_ size: CGSize) -> CIImage? {
        let scaleX = size.width / extent.size.width
        let scaleY = size.height / extent.size.height
        
        return transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
    }
    
    public func color(foregroundColor: UIColor, backgroundColor: UIColor) -> CIImage? {
        let foregroundCoreColor = CIColor(uiColor: foregroundColor)
        let backgroundCoreColor = CIColor(uiColor: backgroundColor)
        
        let colorFilter = CIFilter(name: "CIFalseColor", parameters: ["inputImage": self, "inputColor0":foregroundCoreColor, "inputColor1":backgroundCoreColor])
        
        return colorFilter?.outputImage
    }
}

extension CIColor {
    convenience init(uiColor: UIColor) {
        let foregroundColorRef = uiColor.cgColor
        let foregroundColorString = CIColor(cgColor: foregroundColorRef).stringRepresentation
        
        self.init(string: foregroundColorString)
    }
}
