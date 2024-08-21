//
//  Endpoint.swift
//  online-course-app
//
//  Created by @suonvicheakdev on 30/7/24.
//

import Foundation

enum Endpoint: String {
    
    static let endpoint = "https://api.cheakautomate.online/api/v1/"
    
    case login
    case refreshToken
    case register
    case verifyCode
    case resendCode
    case forgetPassword
    case resetPassword
    case userProfile
    case uploadUserPhotoByUuid
    case updateUserProfileByUuid
    case changePassword
    case loadCoursesWithCategory
    case loadCourseByUuid
    case searchCourses
    case createNewCourse
    case updateCourseByUuid
    case deleteCourseByUuid
    case loadVideosByCourseUuid
    case loadCoursesByAuthenticatedAuthor
    case loadVideoByUuid
    case enroll
    case loadSubscriptionByAuthenticatedSubscriber
    case loadSubscriptionByAuthenticatedAuthor
    case approveOrRejectSubscription
    
    var rawValue: String {
        switch self {
        case .login:
            return Endpoint.endpoint + "auth/login"
        case .refreshToken:
            return Endpoint.endpoint + "auth/refreshToken"
        case .register:
            return Endpoint.endpoint + "auth/register"
        case .verifyCode:
            return Endpoint.endpoint + "auth/verify"
        case .resendCode:
            return Endpoint.endpoint + "auth/send-verification-code"
        case .forgetPassword:
            return Endpoint.endpoint + "auth/forget-password"
        case .resetPassword:
            return Endpoint.endpoint + "auth/reset-password"
        case .userProfile:
            return Endpoint.endpoint + "users/me"
        case .uploadUserPhotoByUuid:
            return Endpoint.endpoint + "users/uploadImage/"
        case .updateUserProfileByUuid:
            return Endpoint.endpoint + "users/"
        case .changePassword:
            return Endpoint.endpoint + "users/change-password/"
        case .loadCoursesWithCategory:
            return Endpoint.endpoint + "categories/"
        case .loadCourseByUuid:
            return Endpoint.endpoint + "courses/"
        case .searchCourses:
            return Endpoint.endpoint + "courses/search?"
        case .createNewCourse:
            return Endpoint.endpoint + "courses"
        case .updateCourseByUuid:
            return Endpoint.endpoint + "courses/"
        case .deleteCourseByUuid:
            return Endpoint.endpoint + "courses/"
        case .loadVideosByCourseUuid:
            return Endpoint.endpoint + "courses/"
        case .loadCoursesByAuthenticatedAuthor:
            return Endpoint.endpoint + "courses/me"
        case .loadVideoByUuid:
            return Endpoint.endpoint + "videos/"
        case .enroll:
            return Endpoint.endpoint + "subscriptions"
        case .loadSubscriptionByAuthenticatedSubscriber:
            return Endpoint.endpoint + "subscriptions/subscriber/reports"
        case .loadSubscriptionByAuthenticatedAuthor:
            return Endpoint.endpoint + "subscriptions/author/reports"
        case .approveOrRejectSubscription:
            return Endpoint.endpoint + "subscriptions"
        }
    }
    
}
