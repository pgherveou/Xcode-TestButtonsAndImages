
import UIKit

class ViewController: UIViewController {
}

// MARK: CircleComponent protocol

protocol CircleComponent {
  var circleSize: CGFloat { get }
  var borderColor: UIColor { get }
  var borderWidth: CGFloat { get }

  var hasCircleMaskLayer: Bool { get }
  var hasRingLayer: Bool { get }

  var ringLayer: CAShapeLayer? { get set }
  var maskLayer: CAShapeLayer? { get set }
}

// MARK: RoundedRectComponent protocol

protocol RoundedRectComponent {
  var roundedRectSize: CGSize { get }
  var borderColor: UIColor { get }
  var borderWidth: CGFloat { get }
  var cornerRadius: CGFloat { get }

  var hasRoundedRectMaskLayer: Bool { get }
  var hasRoundedRectLayer: Bool { get }

  var maskLayer: CAShapeLayer? { get set }
  var roundedRectLayer: CAShapeLayer? { get set }
}

// MARK: CircleComponent helpers

private func circleComponentLayoutSubviews<T:UIView where T:CircleComponent>(view: T) {

  let center = CGPoint(
    x: view.bounds.midX,
    y: view.bounds.midY
  )

  // either use circleSize or view size to size our circle
  let rect: CGRect
  if view.circleSize > 0 {
    rect = CGRect(x: 0, y: 0, width: view.circleSize, height: view.circleSize)
  } else {
    let side = min(view.bounds.height, view.bounds.width)
    rect = CGRect(x: 0, y: 0, width: side, height: side)
  }

  // append ring layer if required
  if view.hasRingLayer && view.ringLayer == nil {
    view.ringLayer = CAShapeLayer()
    view.layer.insertSublayer(view.ringLayer, atIndex: 0)
  }

  // setup ring layer dimensions
  if let ringLayer = view.ringLayer {
    let innerRect = CGRectInset(rect, view.borderWidth / 2.0, view.borderWidth / 2.0)
    let innerPath = UIBezierPath(ovalInRect: innerRect)

    ringLayer.bounds = rect
    ringLayer.path = innerPath.CGPath
    ringLayer.fillColor = nil
    ringLayer.lineWidth = view.borderWidth
    ringLayer.strokeColor = view.borderColor.CGColor
    ringLayer.position = center
  }

  // append mask layer if required
  if view.hasCircleMaskLayer && view.maskLayer == nil {
    view.maskLayer = CAShapeLayer()
    view.layer.mask = view.maskLayer
  }

  // setup mask layer dimension
  if let maskLayer = view.maskLayer {
    let innerRect = CGRectInset(rect, view.borderWidth / 2.0, view.borderWidth / 2.0)
    let innerPath = UIBezierPath(ovalInRect: innerRect)

    maskLayer.bounds = rect
    maskLayer.path = innerPath.CGPath
    maskLayer.fillColor = UIColor.blackColor().CGColor
    maskLayer.lineWidth = max(view.borderWidth - 1, 0)
    maskLayer.strokeColor = UIColor.blackColor().CGColor
    maskLayer.position = center
  }

  // setup icon color
  view.tintColor = view.tintColor
}

private func circleComponentIntrinsicContentSize<T:UIView where T:CircleComponent>(view: T) -> CGSize? {
  if view.circleSize > 0 {
    return CGSize(width: view.circleSize, height: view.circleSize)
  }

  return nil
}

// MARK: RoundedRectComponent helper

private func roundedRectComponentLayoutSubviews<T:UIView where T:RoundedRectComponent>(view: T) {

  // view center
  let center = CGPoint(
    x: view.bounds.midX,
    y: view.bounds.midY
  )

  // either use the frame size or the one specified to size the rounded rect
  let rect = view.roundedRectSize == CGSizeZero
    ? view.bounds
    : CGRect(origin: CGPointZero, size: view.roundedRectSize)

  // append ring layer if required
  if view.hasRoundedRectLayer && view.roundedRectLayer == nil {
    view.roundedRectLayer = CAShapeLayer()
    view.layer.insertSublayer(view.roundedRectLayer, atIndex: 0)
  }

  // setup ring layer dimensions
  if let roundedRectLayer = view.roundedRectLayer {
    let innerRect = CGRectInset(rect, view.borderWidth / 2.0, view.borderWidth / 2.0)
    let innerPath = UIBezierPath(roundedRect: innerRect, cornerRadius: view.cornerRadius)

    roundedRectLayer.bounds = rect
    roundedRectLayer.path = innerPath.CGPath
    roundedRectLayer.fillColor = nil
    roundedRectLayer.lineWidth = view.borderWidth
    roundedRectLayer.strokeColor = view.borderColor.CGColor
    roundedRectLayer.position = center
  }

  // append mask layer if required
  if view.hasRoundedRectMaskLayer && view.maskLayer == nil {
    view.maskLayer = CAShapeLayer()
    view.layer.mask = view.maskLayer
  }

  // setup mask layer dimension
  if let maskLayer = view.maskLayer {
    let innerRect = CGRectInset(rect, view.borderWidth / 2.0, view.borderWidth / 2.0)
    let innerPath = UIBezierPath(roundedRect: innerRect, cornerRadius: view.cornerRadius)

    maskLayer.bounds = rect
    maskLayer.path = innerPath.CGPath
    maskLayer.fillColor = UIColor.blackColor().CGColor
    maskLayer.lineWidth = max(view.borderWidth - 1, 0)
    maskLayer.strokeColor = UIColor.blackColor().CGColor
    maskLayer.position = center
  }

  // setup icon color
  view.tintColor = view.tintColor
}

private func roundedRectComponentIntrinsicContentSize<T:UIView where T:RoundedRectComponent>(view: T) -> CGSize? {
  if view.roundedRectSize != CGSizeZero {
    return view.roundedRectSize
  }

  return nil
}


// MARK: CircleView

@IBDesignable
class CircleView: UIView, CircleComponent {

  @IBInspectable
  var circleSize: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var borderColor: UIColor = UIColor.blackColor() {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var borderWidth: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var hasCircleMaskLayer: Bool = false {
    didSet { setNeedsLayout() }
  }

  var hasRingLayer: Bool { return borderWidth > 0 }
  var ringLayer: CAShapeLayer?
  var maskLayer: CAShapeLayer?

  override func layoutSubviews() {
    super.layoutSubviews()
    circleComponentLayoutSubviews(self)
  }

  override func intrinsicContentSize() -> CGSize {
    return circleComponentIntrinsicContentSize(self) ?? super.intrinsicContentSize()
  }
}

// MARK: RoundedRectView

@IBDesignable
class RoundedRectView: UIView, RoundedRectComponent {

  @IBInspectable
  var roundedRectSize: CGSize = CGSizeZero {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var borderColor: UIColor = UIColor.blackColor() {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var borderWidth: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var cornerRadius: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var hasRoundedRectMaskLayer: Bool = false {
    didSet { setNeedsLayout() }
  }

  var hasRoundedRectLayer: Bool { return borderWidth > 0 }

  var maskLayer: CAShapeLayer?
  var roundedRectLayer: CAShapeLayer?

  override func layoutSubviews() {
    super.layoutSubviews()
    roundedRectComponentLayoutSubviews(self)
  }

  override func intrinsicContentSize() -> CGSize {
    return roundedRectComponentIntrinsicContentSize(self) ?? super.intrinsicContentSize()
  }
}

// MARK: Button

@IBDesignable
class Button: UIButton {

  @IBInspectable
  var textAlign: String? {
    didSet { setNeedsLayout() }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    // align image and title
    switch (titleLabel, imageView, textAlign) {
    case let (.Some(titleLabel), .Some(imageView), .Some(textAlign))
         where textAlign == "bottom":
      imageView.frame.origin.x = bounds.midX - imageView.frame.width / 2
      titleLabel.frame.origin.x = bounds.midX - titleLabel.frame.width / 2
      imageView.frame.origin.y = bounds.midY - imageView.frame.height - imageEdgeInsets.bottom
      titleLabel.frame.origin.y = bounds.midY + titleEdgeInsets.top
    case let (.Some(titleLabel), .Some(imageView), .Some(textAlign))
         where textAlign == "top":
      titleLabel.frame.origin.x = bounds.midX - titleLabel.frame.width / 2
      imageView.frame.origin.x = bounds.midX - imageView.frame.width / 2
      titleLabel.frame.origin.y = bounds.midY - titleLabel.frame.height - titleEdgeInsets.bottom
      imageView.frame.origin.y = bounds.midY + imageEdgeInsets.top
    case let (.Some(titleLabel), .Some(imageView), .Some(textAlign))
         where textAlign == "left":
      imageView.frame.origin.y = bounds.midY - imageView.frame.height / 2 + imageEdgeInsets.left
      titleLabel.frame.origin.y = bounds.midY - titleLabel.frame.height / 2 + titleEdgeInsets.right

      let size = titleLabel.frame.width + titleEdgeInsets.right + imageEdgeInsets.left + imageView.frame.width
      titleLabel.frame.origin.x = bounds.midX - size/2
      imageView.frame.origin.x = titleLabel.frame.origin.x + titleLabel.frame.width + titleEdgeInsets.right
    default:
      break
    }
  }

  override func intrinsicContentSize() -> CGSize {
    if let
    imageView = imageView,
    titleLabel = titleLabel,
    textAlign = textAlign
    where textAlign == "top" || textAlign == "bottom" {
      titleLabel.sizeToFit()
      imageView.sizeToFit()
      let height = titleLabel.frame.height + imageView.frame.height
        + titleEdgeInsets.top + titleEdgeInsets.bottom
        + titleEdgeInsets.top + titleEdgeInsets.bottom
        + imageEdgeInsets.top + imageEdgeInsets.bottom
        + 10

      return CGSize(
      width: titleLabel.frame.width + imageView.frame.width,
        height: height
      )
    }

    return super.intrinsicContentSize()
  }
}

// MARK: CircleButton

@IBDesignable
class CircleButton: Button, CircleComponent {

  @IBInspectable
  var circleSize: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var borderColor: UIColor = UIColor.blackColor() {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var borderWidth: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var hasCircleMaskLayer: Bool = false {
    didSet { setNeedsLayout() }
  }

  var hasRingLayer: Bool { return borderWidth > 0 }
  var ringLayer: CAShapeLayer?
  var maskLayer: CAShapeLayer?

  override func layoutSubviews() {
    super.layoutSubviews()
    circleComponentLayoutSubviews(self)
  }

  override func intrinsicContentSize() -> CGSize {
    return circleComponentIntrinsicContentSize(self) ?? super.intrinsicContentSize()
  }
}

// MARK: RoundedRectButton

@IBDesignable
class RoundedRectButton: Button, RoundedRectComponent {

  @IBInspectable
  var roundedRectSize: CGSize = CGSizeZero {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var borderColor: UIColor = UIColor.blackColor() {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var borderWidth: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var cornerRadius: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var hasRoundedRectMaskLayer: Bool = false {
    didSet { setNeedsLayout() }
  }

  var hasRoundedRectLayer: Bool { return borderWidth > 0 }

  var maskLayer: CAShapeLayer?
  var roundedRectLayer: CAShapeLayer?

  override func layoutSubviews() {
    super.layoutSubviews()
    roundedRectComponentLayoutSubviews(self)
  }

  override func intrinsicContentSize() -> CGSize {
    return roundedRectComponentIntrinsicContentSize(self) ?? super.intrinsicContentSize()
  }
}

// MARK: CircleImageView

@IBDesignable
class CircleImageView: UIImageView, CircleComponent {

  @IBInspectable
  var circleSize: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var borderColor: UIColor = UIColor.blackColor() {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var borderWidth: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var hasCircleMaskLayer: Bool = false {
    didSet { setNeedsLayout() }
  }

  var hasRingLayer: Bool { return borderWidth > 0 }
  var ringLayer: CAShapeLayer?
  var maskLayer: CAShapeLayer?

  override func layoutSubviews() {
    super.layoutSubviews()
    circleComponentLayoutSubviews(self)
  }

  override func intrinsicContentSize() -> CGSize {
    return circleComponentIntrinsicContentSize(self) ?? super.intrinsicContentSize()
  }
}

// MARK: RoundedRectImageView

@IBDesignable
class RoundedRectImageView: UIImageView, RoundedRectComponent {

  @IBInspectable
  var roundedRectSize: CGSize = CGSizeZero {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var borderColor: UIColor = UIColor.blackColor() {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var borderWidth: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var cornerRadius: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var hasRoundedRectMaskLayer: Bool = false {
    didSet { setNeedsLayout() }
  }

  var hasRoundedRectLayer: Bool { return borderWidth > 0 }

  var maskLayer: CAShapeLayer?
  var roundedRectLayer: CAShapeLayer?

  override func layoutSubviews() {
    super.layoutSubviews()
    roundedRectComponentLayoutSubviews(self)
  }

  override func intrinsicContentSize() -> CGSize {
    return roundedRectComponentIntrinsicContentSize(self) ?? super.intrinsicContentSize()
  }
}

// MARK: CircleLabel

@IBDesignable
class CircleLabel: UILabel, CircleComponent {

  @IBInspectable
  var circleSize: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var borderColor: UIColor = UIColor.blackColor() {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var borderWidth: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var hasCircleMaskLayer: Bool = false {
    didSet { setNeedsLayout() }
  }

  var hasRingLayer: Bool { return borderWidth > 0 }
  var ringLayer: CAShapeLayer?
  var maskLayer: CAShapeLayer?

  override func layoutSubviews() {
    super.layoutSubviews()
    circleComponentLayoutSubviews(self)
  }

  override func intrinsicContentSize() -> CGSize {
    return circleComponentIntrinsicContentSize(self) ?? super.intrinsicContentSize()
  }
}

// MARK: RoundedRectImageView

@IBDesignable
class RoundedRectLabel: UILabel, RoundedRectComponent {

  @IBInspectable
  var roundedRectSize: CGSize = CGSizeZero {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var borderColor: UIColor = UIColor.blackColor() {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var borderWidth: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var cornerRadius: CGFloat = 0 {
    didSet { setNeedsLayout() }
  }

  @IBInspectable
  var hasRoundedRectMaskLayer: Bool = false {
    didSet { setNeedsLayout() }
  }

  var hasRoundedRectLayer: Bool { return borderWidth > 0 }

  var maskLayer: CAShapeLayer?
  var roundedRectLayer: CAShapeLayer?

  override func layoutSubviews() {
    super.layoutSubviews()
    roundedRectComponentLayoutSubviews(self)
  }

  override func intrinsicContentSize() -> CGSize {
    return roundedRectComponentIntrinsicContentSize(self) ?? super.intrinsicContentSize()
  }
}



