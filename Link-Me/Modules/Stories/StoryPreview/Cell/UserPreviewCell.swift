//
//  UserPreviewCell.swift
//  Link-Me
//
//  Created by Breadfast on 06/08/2023.
//

import UIKit
import AnimatedCollectionViewLayout
import RxSwift
import RxCocoa
import SGSegmentedProgressBarLibrary
import IQKeyboardManagerSwift

enum ButtonState {
    case liked
    case unliked
}

class UserPreviewCell: UICollectionViewCell {
    
    //MARK: - @IBOutlet -
    
    @IBOutlet weak var storyPreviewCollV: UICollectionView!
    @IBOutlet weak var muteSoundBtn: UIButton!
    @IBOutlet weak var comment_tf: UITextField!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImage: CircleImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    //MARK: - Properties -
    
    var currentStory: Int = 0
    var disposedBag = DisposeBag()
    var stories: BehaviorRelay<[Story]> = .init(value: [])
    var comments: BehaviorRelay<[Comments]> = .init(value: [])
    var segmentbar: SGSegmentedProgressBar!
    var previousContentOffset: CGFloat = 0.0
    var closeBtn: (()->())?
    var moreMenuBtn: ((Int?, Int?)->())?
    var muteSound: (()->())?
    var likeBtn: ((Int)->())?
    var addCommentBtn: ((Int,String)->())?
    var chatBtn: (()->())?
    var segmentedProgressBarFinished: ((Bool)->())?
    var isDarg: Bool = false
    var storyCount: Int = 0
    var currentIndex: Int = 0
    private var storyID: Int?
    private var userID: Int?
    var buttonState: ButtonState = .unliked
    var likeStoryID = 0
    
    
    // MARK: - Life Cycle -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setupStoriesCollV()
        setupCommentsTabelview()
        ListenToNotificationCenter()
        configureButton()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposedBag = DisposeBag()
        stories.accept([])
        self.contentView.subviews.forEach { view in
            if view == segmentbar{
                view.removeFromSuperview()
            }
        }
        setupStoriesCollV()
        configureButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.storyPreviewCollV.resizeItem(width: self.frame.size.width, height: self.frame.size.height)
    }
    
    
    private func ListenToNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.NotificationPauseSegment(_:)), name: NSNotification.Name(rawValue: StaticKeys.pauseSegmentController), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.NotificationResumeSegment(_:)), name: NSNotification.Name(rawValue: StaticKeys.resumeSegmentController), object: nil)
    }
    
    @objc func NotificationPauseSegment(_ notification: NSNotification) {
        segmentbar.pause()
    }
    
    @objc func NotificationResumeSegment(_ notification: NSNotification) {
        segmentbar.resume()
    }
    
    
    
    //MARK: - Private Func -
    
    private func setupView(){
        IQKeyboardManager.shared.enable = false
        
        if "lang".localized == "en"{
            comment_tf.setLeftPaddingPoints(5)
        }else{
            comment_tf.setRightPaddingPoints(5)
        }
        
        comment_tf.attributedPlaceholder = NSAttributedString(
            string: "Write Comment ..",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        comment_tf.delegate = self
        comment_tf.iq.toolbar.doneBarButton.setTarget(self, action: #selector(self.doneButtonClicked))
        
        
        storyPreviewCollV.registerNIB(StoryPreviewCell.self)
        storyPreviewCollV.isScrollEnabled = false
        muteSoundBtn.isHidden = true
        
        sendButton.isHidden = true
        commentView.isHidden = true
        
        commentTableView.registerNIB(cell: CommentCell.self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        //TODO: - Please check here.
//        IQKeyboardManager.shared.enable = true
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        if endFrameY >= UIScreen.main.bounds.size.height {
            self.keyboardHeightLayoutConstraint?.constant = 30
        } else {
            self.keyboardHeightLayoutConstraint?.constant = (endFrame?.size.height ?? 0.0) + 10
        }
        
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.contentView.layoutIfNeeded() },
            completion: nil)
    }
    
    
    private func CrossFadeAnimationCollectionView(){
        let layout = AnimatedCollectionViewLayout()
        layout.animator = CrossFadeAttributesAnimator()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        storyPreviewCollV.collectionViewLayout = layout
    }
    
    func setupStoriesCollV(){
        
        storyPreviewCollV.rx.setDelegate(self).disposed(by: disposedBag)
        
        self.stories.bind(to: storyPreviewCollV.rx.items(cellIdentifier: String(describing: StoryPreviewCell.self), cellType: StoryPreviewCell.self)){ (row,item,cell) in
            
            cell.update(item)
            self.storyID = self.stories.value[row].id
            self.userID = self.stories.value[row].userID
            self.segmentbar.currentIndex = row
            print("Comments: \(item.comments ?? [])")
            self.comments.accept(item.comments ?? [])
            self.likeStoryID = item.id ?? 0
            
            if item.likes == 0{
                self.buttonState = .unliked
            }else{
                self.buttonState = .liked
            }
            
            self.configureButton()
            
            cell.nextStory = { [weak self] in
                guard let self = self else {return}
                if self.currentStory == self.stories.value.count - 1{
                    print("no next story")
                }else{
                    self.currentStory += 1
                    print("currentStory: \(self.currentStory)")
                    let indexPath = IndexPath.init(row: self.currentStory, section: 0)
                    self.storyPreviewCollV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                    self.segmentbar.nextSegment()
                    self.storyPreviewCollV.reloadData()
                }
            }
            
            
            cell.previousStory = { [weak self] in
                guard let self = self else {return}
                
                if self.currentStory == 0{
                    
                }else{
                    self.currentStory -= 1
                    let indexPath = IndexPath.init(row: self.currentStory, section: 0)
                    self.storyPreviewCollV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                    self.segmentbar.previousSegment()
                    self.storyPreviewCollV.reloadData()
                }
            }
        }.disposed(by: disposedBag)
    }
    
    private func setupCommentsTabelview(){
        commentTableView.rx.setDelegate(self).disposed(by: disposedBag)
        
        self.comments.bind(to: commentTableView.rx.items(cellIdentifier: String(describing: CommentCell.self), cellType: CommentCell.self)){ (row,item,cell) in
            
            cell.userImage.getImage(imageUrl: item.user?.imagePath ?? "")
            cell.commentLabel.text = item.comment ?? ""
            let creationDate = Date.dateFromString(string: item.created_at ?? "")
            cell.datelabel.text = creationDate.timeAgoDisplay()
            
            
            cell.deleteTap = { [weak self] in
                guard let self = self else {return}
                let repoMyAcc = MyAccountWorker()
                let viewModel = MainStoriesViewModel(myAccount: repoMyAcc)
                print("Row: \(row)")
                
                self.commentTableView.beginUpdates()
                let indexPath = IndexPath(item: row, section: 0)
                self.commentTableView.deleteRows(at: [indexPath], with: .fade)
                self.removeCommentAtIndexPath(indexPath)
                self.commentTableView.endUpdates()
                viewModel.removeComment(commentId: item.id ?? 0)
                
            }
            
        }.disposed(by: disposedBag)
    }
    
  private func removeCommentAtIndexPath(_ indexPath: IndexPath) {
      comments.accept(comments.value.enumerated()
            .filter { index, _ in index != indexPath.row }
            .map { _, element in element })
    }
    
    @objc func doneButtonClicked(_ sender: Any) {
        segmentbar.resume()
        commentView.isHidden = true
        sendButton.isHidden = true
        likeButton.isHidden = false
    }
    
    func configureButton() {
        switch buttonState {
        case .liked:
            likeButton.setImage(UIImage(named: "selectheart"), for: .normal)
            likeButton.tintColor = UIColor.red
        case .unliked:
            likeButton.setImage(UIImage(named: "heart"), for: .normal)
            likeButton.tintColor = UIColor.gray
        }
    }
    
    
    //MARK: - Actoins -
    
    @IBAction func closeTapped(_ sender: Any) {
        closeBtn?()
    }
    
    @IBAction func muteSoundTapped(_ sender: Any) {
        muteSound?()
    }
    
    @IBAction func moreMeunTapped(_ sender: Any) {
        moreMenuBtn?(storyID, userID)
    }
    
    @IBAction func likeTapped(_ sender: Any) {
        likeBtn?(self.likeStoryID)
        
        switch buttonState {
        case .liked:
            buttonState = .unliked
        case .unliked:
            buttonState = .liked
        }
        
        configureButton()
    }
    
    @IBAction func messageTapped(_ sender: Any) {
        chatBtn?()
    }
    
    @IBAction func sendCommentTapped(_ sender: Any) {
        addCommentBtn?(self.likeStoryID, self.comment_tf.text!)
    }
}

//MARK: - SGSegmented Progress Bar Library Configuration -
extension UserPreviewCell: SGSegmentedProgressBarDelegate, SGSegmentedProgressBarDataSource{
    func segmentedProgressBarFinished(finishedIndex: Int, isLastIndex: Bool) {
        if finishedIndex != self.stories.value.count - 1{
            if UDHelper.isDrag{
                if finishedIndex != storyCount{
                    let indexPath = IndexPath.init(row: finishedIndex + 1, section: 0)
                    self.storyPreviewCollV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                    //  self.storyPreviewCollV.reloadData()
                    UDHelper.isDrag = false
                }
            }else{
                let indexPath = IndexPath.init(row: finishedIndex + 1, section: 0)
                self.storyPreviewCollV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                //  self.storyPreviewCollV.reloadData()
            }
        }else{
            if storyCount == segmentbar.numberOfSegments{
                print("is last ya basha")
                self.segmentedProgressBarFinished?(true)
            }
            print("number of segment: \(segmentbar.numberOfSegments)")
        }
    }
    
    private func scrollToNextItemIfNeeded(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.storyPreviewCollV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        self.storyPreviewCollV.reloadData()
    }
    
    var numberOfSegments: Int {
        return stories.value.count
    }
    
    var segmentDuration: TimeInterval {
        return 10
    }
    
    var paddingBetweenSegments: CGFloat {
        return 3
    }
    
    var trackColor: UIColor {
        return UIColor.systemGray2.withAlphaComponent(0.2)
    }
    
    var progressColor: UIColor {
        return UIColor.white
    }
    
    var roundCornerType: SGSegmentedProgressBarLibrary.SGCornerType {
        return .roundCornerBar(cornerRadious: 2)
    }
}

extension UserPreviewCell: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.currentIndex = Int(scrollView.contentOffset.x / storyPreviewCollV.frame.size.width)
        
        
    }
}

//MARK: - Detect Text field events

extension UserPreviewCell: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == comment_tf{
            self.segmentbar.pause()
            sendButton.isHidden = false
            likeButton.isHidden = true
            commentView.isHidden = false
        }
    }
}
