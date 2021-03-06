//
//  NewsPhotoCell.swift
//  VKclient
//
//  Created by Никита Латышев on 25.08.2018.
//  Copyright © 2018 Никита Латышев. All rights reserved.
//

import UIKit

class NewsPhotoCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var iconRepost: UIImageView!
    @IBOutlet weak var iconComment: UIImageView!
    @IBOutlet weak var iconLike: UIImageView!
    @IBOutlet weak var avatarPhoto: UIImageView!
    @IBOutlet weak var viewPhoto: UILabel!{
        didSet {
            viewPhoto.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var repostPhoto: UILabel!{
        didSet {
            repostPhoto.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var commentsPhoto: UILabel!{
        didSet {
            commentsPhoto.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var likePhoto: UILabel!{
        didSet {
            likePhoto.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var authorPhoto: UILabel!{
        didSet {
            authorPhoto.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    let instets: CGFloat = 10.0
    var imageSize: (width: Int, height: Int) = (0, 0)
    let iconSideLinght: CGFloat = 62
    let statisticIcon: CGFloat = 25
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    func setAuthor (text: String){
        authorPhoto.text = text
        author()
    }
    func setLike (text: String){
        likePhoto.text = text
        likeCount()
    }
    func setComment (text: String){
        commentsPhoto.text = text
        commentCount()
    }
    func setRepost (text: String){
        repostPhoto.text = text
        repostCount()
    }
    func setView (text: String){
        viewPhoto.text = text
        viewCount()
    }
    
    
    func getCellHeight() -> CGFloat {
        var height: CGFloat = 0.0
        height = 3 * instets + iconSideLinght + 3 * instets + imagePhoto.frame.size.height + 3 * instets + likePhoto.frame.size.height + 6 * instets
        
        // Проверяем, есть ли изображение в посте
        if imageSize == (0, 0){
            height -= imagePhoto.frame.size.height + 3 * instets
        }
        return height
    }
    
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        // максимальная ширина текста
        let maxWidth = bounds.width - instets * 2
        // размеры блока (макс. ширина и макс. возможная высота)
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        // прямоугольник под текст
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        // ширина и высота блока
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        // размер, округленный до большего целого
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    func avatar () {
        let iconSize = CGSize(width: iconSideLinght, height: iconSideLinght)
        let iconOrigin = CGPoint(x: bounds.midX * 0.05, y: 3 * instets)
        avatarPhoto.frame = CGRect(origin: iconOrigin, size: iconSize)
        
        // закругленные углы
        avatarPhoto.layer.cornerRadius = avatarPhoto.frame.size.width / 2
        avatarPhoto.clipsToBounds = true
    }
    
    
    // Установка размеров и позиции автора новости
    func author () {
        let author = getLabelSize(text: authorPhoto.text!, font: authorPhoto.font)
        let authorX = bounds.width * 0.05 + 62 + bounds.width * 0.05
        let authorY = instets * 5
        let textOrigin = CGPoint(x: authorX, y: authorY)
        authorPhoto.frame = CGRect(origin: textOrigin, size: author)
    }
    
    // Установка размеров и позиции изображения
    func imageViewFrame() {
        guard imageSize.width != 0, imageSize.height != 0 else {
            imagePhoto.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
            return
        }
        let ratio = Double(imageSize.height) / Double(imageSize.width)
        let y = 3 * instets + iconSideLinght + 3 * instets
        let width = Double(bounds.width - instets * 2)
        let height = width * ratio
        let size = CGSize(width: width, height: ceil(height))
        let origin = CGPoint(x: instets, y: y)
        imagePhoto.frame = CGRect(origin: origin, size: size)
    }
    
    // Установка размеров и позиции изображения Like
    func likeIcon () {
        let iconSize = CGSize(width: statisticIcon, height: statisticIcon)
        let iconOrigin = CGPoint(x: bounds.width * 0.05, y: 3 * instets + iconSideLinght + 3 * instets + imagePhoto.frame.size.height + 3 * instets)
        iconLike.frame = CGRect(origin: iconOrigin, size: iconSize)
    }
    
    // Установка размеров и позиции количества Like
    func likeCount() {
        // получаем размер текста
        let text = getLabelSize(text: likePhoto.text!, font: likePhoto.font)
        // рассчитываем координату по оси X
        let textX = bounds.width * 0.05 + 3 * instets
        let textY = 9 * instets + iconSideLinght + imagePhoto.frame.size.height
        // получаем координаты верхней левой точки
        let textOrigin = CGPoint(x: textX, y: textY)
        // получаем фрейм и установливаем его UILabel
        likePhoto.frame = CGRect(origin: textOrigin, size: text)
    }
    
    // Установка размеров и позиции изображения Comment
    func commentIcon () {
        let iconSize = CGSize(width: statisticIcon, height: statisticIcon)
        let iconOrigin = CGPoint(x: bounds.width * 0.05 + 3 * instets + likePhoto.frame.size.width + bounds.width * 0.07, y: 3 * instets + iconSideLinght + 3 * instets + imagePhoto.frame.size.height + 3 * instets)
        iconComment.frame = CGRect(origin: iconOrigin, size: iconSize)
    }
    
    // Установка размеров и позиции количества Comment
    func commentCount() {
        // получаем размер текста
        let text = getLabelSize(text: commentsPhoto.text!, font: commentsPhoto.font)
        // рассчитываем координату по оси X
        let textX = bounds.width * 0.05 + 3 * instets + likePhoto.frame.size.width + bounds.width * 0.07 + 3 * instets
        let textY = 9 * instets + iconSideLinght + imagePhoto.frame.size.height
        // получаем координаты верхней левой точки
        let textOrigin = CGPoint(x: textX, y: textY)
        // получаем фрейм и установливаем его UILabel
        commentsPhoto.frame = CGRect(origin: textOrigin, size: text)
    }
    
    // Установка размеров и позиции изображения Repost
    func repostIcon() {
        let iconSize = CGSize(width: statisticIcon, height: statisticIcon)
        let iconOrigin = CGPoint(x: bounds.width * 0.05 + 3 * instets + likePhoto.frame.size.width + bounds.width * 0.07 + 3 * instets + bounds.width * 0.07, y: 3 * instets + iconSideLinght + 3 * instets + imagePhoto.frame.size.height + 3 * instets)
        iconRepost.frame = CGRect(origin: iconOrigin, size: iconSize)
    }
    
    // Установка размеров и позиции количества Repost
    func repostCount() {
        // получаем размер текста
        let text = getLabelSize(text: repostPhoto.text!, font: repostPhoto.font)
        // рассчитываем координату по оси X
        let textX = bounds.width * 0.05 + 3 * instets + likePhoto.frame.size.width + bounds.width * 0.07 + 3 * instets + commentsPhoto.frame.size.width + bounds.width * 0.07 + 3 * instets
        let textY = 9 * instets + iconSideLinght + imagePhoto.frame.size.height
        // получаем координаты верхней левой точки
        let textOrigin = CGPoint(x: textX, y: textY)
        // получаем фрейм и установливаем его UILabel
        repostPhoto.frame = CGRect(origin: textOrigin, size: text)
    }
    
    // Установка размеров и позиции изображения View
    func viewIcon() {
        let iconSize = CGSize(width: statisticIcon, height: statisticIcon)
        let iconOrigin = CGPoint(x: bounds.width * 0.05 + 3 * instets + likePhoto.frame.size.width + bounds.width * 0.07 + 3 * instets + commentsPhoto.frame.size.width + bounds.width * 0.07 + 3 * instets + repostPhoto.frame.size.width + bounds.width * 0.07, y: 3 * instets + iconSideLinght + 3 * instets + imagePhoto.frame.size.height + 3 * instets)
        iconView.frame = CGRect(origin: iconOrigin, size: iconSize)
    }
    
    // Установка размеров и позиции количества View
    func viewCount() {
        // получаем размер текста
        let text = getLabelSize(text: viewPhoto.text!, font: viewPhoto.font)
        // рассчитываем координату по оси X
        let textX = bounds.width * 0.05 + 3 * instets + likePhoto.frame.size.width + bounds.width * 0.07 + 3 * instets + commentsPhoto.frame.size.width + bounds.width * 0.07 + 3 * instets + repostPhoto.frame.size.width + bounds.width * 0.07 + 3 * instets
        let textY = 9 * instets + iconSideLinght + imagePhoto.frame.size.height
        // получаем координаты верхней левой точки
        let textOrigin = CGPoint(x: textX, y: textY)
        // получаем фрейм и установливаем его UILabel
        viewPhoto.frame = CGRect(origin: textOrigin, size: text)
    }
    
    func attachments (news: News, cell: NewsCell, indexPath: IndexPath, tableView: UITableView){
        if let attachments = news.attachments {
            imageSize = (attachments.width, attachments.height)
            imageViewFrame()
            
            let getCacheImage = GetCacheImage(url: attachments.url)
            getCacheImage.completionBlock = {
                OperationQueue.main.addOperation {
                    self.imagePhoto.image = getCacheImage.outputImage
                }
            }
            
            let setImageToRow = SetImageToRow(cell: cell, indexPath: indexPath, tableView: tableView)
            setImageToRow.addDependency(getCacheImage)
            queue.addOperation(getCacheImage)
            OperationQueue.main.addOperation(setImageToRow)
            
        } else {
            imageSize = (0, 0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatar ()
        author ()
        imageViewFrame()
        likeIcon ()
        likeCount()
        commentIcon()
        commentCount()
        repostIcon()
        repostCount()
        viewIcon()
        viewCount()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
