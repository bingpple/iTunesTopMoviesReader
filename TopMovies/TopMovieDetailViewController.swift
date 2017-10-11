//
//  TopMovieDetailViewController.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2017 Bing Cai
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit
import WebKit
import AVKit


class TopMovieDetailViewController: UIViewController {
  
  var movieDetailContent = ""
  var movieName = ""
  var movieTrailerAddress: String = ""
  fileprivate var player = Player()

  @IBOutlet weak var movieDetailWebView: WKWebView!
  @IBOutlet weak var movieTrailerContainerView: UIView!
  
  // MARK: object lifecycle
  deinit {
    self.player.willMove(toParentViewController: self)
    self.player.view.removeFromSuperview()
    self.player.removeFromParentViewController()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = movieName
    movieDetailWebView.loadHTMLString(movieDetailContent, baseURL: nil)
    
  }
  
  @IBAction func playMovieTrailer(_ sender: Any) {
    self.player.playerDelegate = self
    self.player.playbackDelegate = self
    self.player.view.frame = self.movieTrailerContainerView.bounds

    self.player.url = URL(string: movieTrailerAddress)
    self.player.playbackLoops = false
    
    //Single tap to stop and play
    let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
    tapGestureRecognizer.numberOfTapsRequired = 1
    self.player.view.addGestureRecognizer(tapGestureRecognizer)
    self.movieTrailerContainerView.addSubview(self.player.view)
    self.player.playFromBeginning()
    
  }
  
}

// MARK: - UIGestureRecognizer
extension TopMovieDetailViewController {
  
  @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
    switch (self.player.playbackState.rawValue) {
    case PlaybackState.stopped.rawValue:
      self.player.playFromBeginning()
      break
    case PlaybackState.paused.rawValue:
      self.player.playFromCurrentTime()
      break
    case PlaybackState.playing.rawValue:
      self.player.pause()
      break
    case PlaybackState.failed.rawValue:
      self.player.pause()
      break
    default:
      self.player.pause()
      break
    }
  }
  
}

// MARK: - PlayerDelegate
extension TopMovieDetailViewController:PlayerDelegate {
  
  func playerReady(_ player: Player) {
  }
  
  func playerPlaybackStateDidChange(_ player: Player) {
  }
  
  func playerBufferingStateDidChange(_ player: Player) {
  }
  
  func playerBufferTimeDidChange(_ bufferTime: Double) {
  }
  
}

// MARK: - PlayerPlaybackDelegate
extension TopMovieDetailViewController:PlayerPlaybackDelegate {
  
  func playerCurrentTimeDidChange(_ player: Player) {
  }
  
  func playerPlaybackWillStartFromBeginning(_ player: Player) {
  }
  
  func playerPlaybackDidEnd(_ player: Player) {
  }
  
  func playerPlaybackWillLoop(_ player: Player) {
  }
  
}
