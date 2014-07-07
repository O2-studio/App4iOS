//
//  ETModelViewController.h
//  etaoshopping
//
//  Created by moxin.xt on 12-10-13.
//
//

#import "ETBaseModel.h"

/**
 *  model请求和回调的逻辑
 */
@interface ETModelViewController : ETUIViewController<ETModelDelegate>
{
@protected
    NSMutableDictionary* _modelDictInternal;
}

/**
 *  保存model
 */
@property(nonatomic,strong,readonly) NSDictionary* modelDictionary;

/**
 *  注册要请求的model
 *
 *  @param model 注册后model会被modelDictionary引用
 */
- (void)registerModel:(ETBaseModel *)model;
/**
 *  取消注册model
 *
 *  @param model 取消注册后model会从modelDictionary中移除
 */
- (void)unRegisterModel:(ETBaseModel *)model;
/**
 *  遍历所有model，请求数据
 */
- (void)load;
/**
 *  遍历所有model，重新请求数据
 */
- (void)reload;
/**
 *  遍历所有model，继续加载数据
 */
- (void)loadMore;

@end


@interface ETModelViewController(Subclassing)
/**
 *  model请求完成后会被调用
 *
 *  @param model 请求完成的model
 */
- (void)didLoadModel:(ETBaseModel*)model;
/**
 *  model显示前会被调用
 *
 *  @param model 待显示的model
 *
 *  @return bool
 */
- (BOOL)canShowModel:(ETBaseModel*)model;
/**
 *  界面不显示model的状态
 *
 *  @param model 请求完成的model或者nil
 */
- (void)showEmpty:(ETBaseModel *)model;
/**
 *  界面显示model数据
 *
 *  @param model 待显示的model
 */
- (void)showModel:(ETBaseModel *)model;
/**
 *  界面显示model加载的状态
 *
 *  @param model 正在加载的model
 */
- (void)showLoading:(ETBaseModel *)model;
/**
 *  界面显示model错误的状态
 *
 *  @param error 返回的错误
 *  @param model 错误的model
 */
- (void)showError:(NSError *)error withModel:(ETBaseModel*)model;

@end