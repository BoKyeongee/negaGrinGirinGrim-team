//
//  DetailViewController.swift
//  nagaGrinGirinGrim
//
//  Created by Jack Lee on 2023/08/14.
//

import UIKit

class DetailViewController: UIViewController {
    
//MARK: - UIOutlet
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var addPostButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!

    @IBOutlet weak var reactionButton: UIButton!
    @IBOutlet weak var reactionTracker: UILabel!

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var detailDateLabel: UILabel!
    @IBOutlet weak var detailBodyLabel: UILabel!

    @IBOutlet weak var firstEmoji: UIButton!
    @IBOutlet weak var secondEmoji: UIButton!
    @IBOutlet weak var thirdEmoji: UIButton!
    @IBOutlet weak var fourthEmoji: UIButton!
    
// MARK: - 전역변수
    
    var reactionCollection: [String: Int] = [:]
    var firstReactionCount = 0
    var secondReactionCount = 0
    var thirdReactionCount = 0
    var fourthReactionCount = 0
    var imageIndex = 0
    var currentImageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        enableSwipe()
                
        // 이미지 뷰 클릭 액션
        let profileImageTapped = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(profileImageTapped)
    }
    
    // MARK: - 어플 셋업
    
    func setupUI() {
        setupImages()
        setupEmojiButtons()
        populateData()
        setupEdit()
        setupView()
    }
    
    func setupImages() {
        setupProfile()
        setupPostImage()
        setupPageControl()
    }
    
    func setupProfile() {
        profileImage.image = UIImage(named: userData.profile.profilePicture)
        profileNameLabel.text = userData.profile.userName
        profileImage.backgroundColor = .black
        profileImage.layer.borderWidth = 0.25
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = 20
        profileImage.contentMode = .scaleAspectFit
    }
    
    func viewLayout(_ view: UIView) {
        view.layer.cornerRadius = 30
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 6
    }
    
    func setupPostImage() {
        viewLayout(postedImage)
        postedImage.layer.borderWidth = 0.5
        postedImage.layer.borderColor = UIColor.black.cgColor
    }
    
    func setupPageControl() {
        pageControl.currentPageIndicatorTintColor = .yellow
        pageControl.pageIndicatorTintColor = .lightGray
    }

    func setupEmojiButtons() {
        let emojiSet = ["🫠","🔥","⭐️","❤️"]
        let buttons = [firstEmoji, secondEmoji, thirdEmoji, fourthEmoji]
        
        for (index,button) in buttons.enumerated() {
            if index < emojiSet.count {
                button?.setTitle(emojiSet[index], for: .normal)
                button?.layer.cornerRadius = 20
                button?.layer.borderWidth = 1
                button?.layer.borderColor = UIColor.gray.cgColor
                button?.backgroundColor = .white
                button?.clipsToBounds = true
            }
        }
    }
    
    func populateData() {
        if let selectedIndexPath = defaults.value(forKey: "current") as? Int {
            if selectedIndexPath >= 0 && selectedIndexPath < userData.postImgNames.count {
                let postImageName = userData.postImgNames[selectedIndexPath]
                let postTitle = userData.postTitles[selectedIndexPath]
                let postDate = userData.postDates[selectedIndexPath]
                let postContent = userData.postContents[selectedIndexPath]
                
                postedImage.image = UIImage(named: postImageName)
                detailBodyLabel.text = postContent
                detailDateLabel.text = postDate
                detailTitleLabel.text = postTitle
                pageControl.numberOfPages = postImageName.count
                pageControl.hidesForSinglePage = true
            } else {
                // 에러 처리 안되는 중...
                let errorHandler = ErrorHandler()
                errorHandler.displayError(for: .needtoReload)
            }
        }
    }
    
    func setupEdit() {
        editButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
    }
    
    func setupView() {
        containerView.backgroundColor = UIColor(red: 255/255,
                                                green: 232/255,
                                                blue: 105/255,
                                                alpha: 0.6)
        viewLayout(containerView)
    }
    
    func enableSwipe() {
        postedImage.isUserInteractionEnabled = true
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe))
        swipeLeft.direction = .left
        postedImage.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe))
        swipeRight.direction = .right
        postedImage.addGestureRecognizer(swipeRight)
    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
//        postedImage.image = UIImage(named: userData.postImgNames[sender.currentPage])
    }
    
    @IBAction func backAct(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // VC가 존재할 경우, 재활용하여 불러오는 방법 - if not 생성
    @IBAction func addPostButtonTapped(_ sender: UIButton) {
        if let writingViewController = self.navigationController?.viewControllers.first(where: { $0 is WritingViewController }) as? WritingViewController {
            self.navigationController?.pushViewController(writingViewController, animated: true)
        }
        let writingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "writingViewControllerID") as! WritingViewController
        self.navigationController?.pushViewController(writingViewController, animated: true)
    }
    
    @IBAction func reactionButtonTapped(_ sender: UIButton) {
        print("반응 갯수를 확인합니다")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "DetailPopupID")
        
        if let reactionViewController = viewController.presentationController as? UISheetPresentationController {
            reactionViewController.detents = [.medium()]
        }
        self.present(viewController, animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        print("오른쪽 버튼이 눌렸습니다.")
        guard let image = postedImage.image else { return }
        let shareSheetVC = UIActivityViewController(activityItems: [image],
                                                    applicationActivities: nil)
        present(shareSheetVC, animated: true)
    }
    
    @objc func profileImageTapped() {
        let ProfileViewControllerID = UIStoryboard(name: "Main", bundle: .none).instantiateViewController(identifier: "profileViewControllerID") as! ProfileViewController
        navigationController?.pushViewController(ProfileViewControllerID, animated: true)
    }
    
    @IBAction func EmojiButtonTapped(_ sender: UIButton) {
        let totalCount = reactionCollection.values.reduce(1, +)
        sender.animateButton(sender)
        
        switch sender {
        case firstEmoji:
            let reaction = "🫠"
            firstReactionCount += 1
            reactionCollection.updateValue(firstReactionCount, forKey: reaction)
            reactionTracker.text = "\(totalCount)"
            
        case secondEmoji:
            let reaction = "🔥"
            secondReactionCount += 1
            reactionCollection.updateValue(secondReactionCount, forKey: reaction)
            reactionTracker.text = "\(totalCount)"
            
            reactionButton.setImage(UIImage(systemName: "heart.suit.fill"), for: .normal)
            
        case thirdEmoji:
            let reaction = "⭐️"
            thirdReactionCount += 1
            reactionCollection.updateValue(thirdReactionCount, forKey: reaction)
            reactionTracker.text = "\(totalCount)"
            
        case fourthEmoji:
            let reaction = "❤️"
            fourthReactionCount += 1
            reactionCollection.updateValue(fourthReactionCount, forKey: reaction)
            reactionTracker.text = "\(totalCount)"

        default: print("에러가 발생했습니다.")
        }
    }
    
    @objc func respondToSwipe(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .left:
                print("오른쪽으로 이동")
                imageIndex = (imageIndex + 1) % userData.postImgNames.count
                postedImage.image = UIImage(named: userData.postImgNames[imageIndex])

            case .right:
                print("왼쪽으로 이동")
                imageIndex = (imageIndex - 1 + userData.postImgNames.count) % userData.postImgNames.count
                postedImage.image = UIImage(named: userData.postImgNames[imageIndex])

            default:
                print("오류 발생")
            }
        }
    }
}

extension DetailViewController: UISheetPresentationControllerDelegate {
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func navigationBarHidden() {
        self.navigationController?.navigationBar.isHidden = true
    }
}
