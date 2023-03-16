//
//  CustomInterceptor.swift
//  FormApp
//
//  Created by Hany Alkahlout on 09/03/2023.
//

import Foundation
import Alamofire
import SVProgressHUD

class CustomInterceptor: RequestInterceptor{
    
    //    let retry = 3 // set the count for number of retries
    //
    //    // [Request url: Number of times retried]
    //    private var retriedRequests: [String: Int] = [:]
    //
    //    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
    //        guard
    //            request.task?.response == nil,
    //            let url = request.request?.url?.absoluteString
    //        else {
    //            removeCachedUrlRequest(url: request.request?.url?.absoluteString)
    //            completion(.doNotRetry) // don't retry
    //            return
    //        }
    //
    //
    //        guard let retryCount = retriedRequests[url] else {
    //            retriedRequests[url] = 1
    //            DispatchQueue.global(qos: .background).async {
    //                completion(.retryWithDelay(0.5)) // retry after 0.5 second
    //            }
    //
    //            return
    //        }
    //
    //        if retryCount < retry { // check remaining retries available
    //            retriedRequests[url] = retryCount + 1
    //            completion(.retryWithDelay(0.5)) // retry after 0.5 second
    //        } else {
    //            removeCachedUrlRequest(url: url)
    //            completion(.doNotRetry) // don't retry
    //        }
    //
    //    }
    //
    //
    //    private func removeCachedUrlRequest(url: String?) {
    //        guard let url = url else {
    //            return
    //        }
    //        retriedRequests.removeValue(forKey: url)
    //    }
    
    //    private let retry = 1
    //
    //
    //    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
    //        SVProgressHUD.dismiss()
    //
    //        AppManager.shared.monitorNetwork { [weak self] in
    //            guard let self = self else { return }
    //            guard
    //                request.task?.response == nil,
    //                let url = request.request?.url?.absoluteString
    //                else {
    //                self.removeCachedUrlRequest(url: request.request?.url?.absoluteString)
    //                completion(.doNotRetry)
    //                    return
    //            }
    //
    //            guard let retryCount = self.retriedRequests[url] else {
    //                self.retriedRequests[url] = 1
    //                completion(.retryWithDelay(0.5)) // retry after 0.5 second
    //                return
    //            }
    //
    //            if retryCount < self.retry { // check remaining retries available
    //                self.retriedRequests[url] = retryCount + 1
    //                completion(.retryWithDelay(0.5)) // retry after 0.5 second
    //            } else {
    //                self.removeCachedUrlRequest(url: url)
    //                completion(.doNotRetry) // don't retry
    //            }
    //            print("Retry Count: \(request.retryCount)")
    //        } notConectedAction: {
    //            completion(.doNotRetry)
    //        }
    //    }
    //
    //
    //
    //    // [Request url: Number of times retried]
    //    private var retriedRequests: [String: Int] = [:]
    //
    //
    //    // removes requests completed
    //    private func removeCachedUrlRequest(url: String?) {
    //        guard let url = url else {
    //            return
    //        }
    //        retriedRequests.removeValue(forKey: url)
    //    }

    
}
