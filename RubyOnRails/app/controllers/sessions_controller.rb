#encoding:utf-8
class SessionsController < ApplicationController

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id

      if (params[:remember].present?)
        cookies.permanent[:email_hash] = user.email_hash
        cookies.permanent[:user_id] = user.id
      end

      # TODO
      #if (params[:redirect].present? && !params[:redirect].include?('forgot_password'))
      #  redirect_to params[:redirect]
      #else
      #  redirect_to root_url
      #end
      
      redirect_to root_url
    else
      redirect_to login_accounts_path, :alert => (t :login_error)
    end
  end

  def destroy
    session[:user_id] = nil
    cookies.delete :email_hash
    cookies.delete :user_id
    redirect_to root_url
  end

  def oauth_success
    provider_name = params[:provider]
    user_info = request.env["omniauth.auth"][:extra][:raw_info]
    #"omniauth.auth"=>#<OmniAuth::AuthHash credentials=#<Hashie::Mash expires=true expires_at=1345149696 token="2ea671622bf3eb218bf3542683dbc163">

    if ('xiaonei' == provider_name)
      uid = user_info[:uid]
    elsif ('qq_connect' == provider_name)
      uid = request.env["omniauth.auth"][:uid]
    else
      uid = user_info[:id]
    end

    auth_provider = Provider.find_by_provider_and_uid(provider_name, uid)

    if (auth_provider.present?)
      session[:user_id] = auth_provider.user.id

      if auth_provider.user.email.blank?
        redirect_to complete_info_accounts_path
      else
        redirect_to root_url
      end
    else
      info = {}

      case provider_name
      when 'douban'
        #<Hashie::Mash alt="http://www.douban.com/people/DreamerWang/" avatar="http://img3.douban.com/icon/u1534763-9.jpg" created="2007-04-30 22:14:44" desc="Talk is cheap. Real artists ship.\n\nhttp://www.zhuoqun.net" id="1534763" loc="北京" name="zhuoqun" status="self" uid="DreamerWang">

        info[:user_name] = user_info[:name]
        info[:gender] = -1
        info[:avatar] = user_info[:avatar]
        info[:location] = user_info[:loc]

        info[:uid] = user_info[:id]
        info[:url] = user_info[:alt]

      when 'weibo'
        #<Hashie::Mash allow_all_act_msg=false allow_all_comment=true avatar_large="http://tp2.sinaimg.cn/1661293025/180/5635994420/1" bi_followers_count=208 city="8" created_at="Mon Nov 16 11:53:45 +0800 2009" description="有梦想，不抱怨。" domain="zhuoqun" favourites_count=509 follow_me=false followers_count=1598 following=false friends_count=312 gender="m" geo_enabled=true id=1661293025 idstr="1661293025" lang="zh-cn" location="北京 海淀区" name="zhuoqun" online_status=0 profile_image_url="http://tp2.sinaimg.cn/1661293025/50/5635994420/1" profile_url="zhuoqun" province="11" remark="" screen_name="zhuoqun" 

        info[:user_name] = user_info[:screen_name]

        gender = {'m' => 1, 'f' => 0, 'n' => -1}
        info[:gender] = gender[user_info[:gender]]

        info[:avatar] = user_info[:avatar_large]
        info[:location] = user_info[:location]

        info[:uid] = user_info[:id]
        info[:url] = 'http://weibo.com/' + user_info[:profile_url]

      when 'xiaonei'
        #<Hashie::Mash headurl="http://hdn101.rrimg.com/photos/hdn101/20081015/12/08/head_jV0d_440h000001.jpg" name="王卓群" sex=1 star=0 tinyurl="http://hdn101.rrimg.com/photos/hdn101/20081015/12/08/tiny_VETD_440h000001.jpg" uid=700007786 vip=1 zidou=0>

        info[:user_name] = user_info[:name]
        info[:gender] = user_info[:sex]
        info[:avatar] = user_info[:headurl]
        info[:location] = ''

        info[:uid] = user_info[:uid]
        info[:url] = 'http://www.renren.com/profile.do?id=' + user_info[:uid].to_s


      when 'qq_connect'
        #<OmniAuth::AuthHash credentials=#<Hashie::Mash expires=true expires_at=1352922344 token="42C2A3B7FE7B67EDC94B0701CCE6FE5F"> extra=#<Hashie::Mash> info=#<OmniAuth::AuthHash::InfoHash figureurl="http://qzapp.qlogo.cn/qzapp/100296872/F54D2A707EB31C292A12A58049151C3D/30" figureurl_1="http://qzapp.qlogo.cn/qzapp/100296872/F54D2A707EB31C292A12A58049151C3D/50" figureurl_2="http://qzapp.qlogo.cn/qzapp/100296872/F54D2A707EB31C292A12A58049151C3D/100" gender="男" level="0" msg="" nickname="Dreamer" ret=0 vip="0"> provider="qq_connect" uid="F54D2A707EB31C292A12A58049151C3D">
        
        user_info = request.env["omniauth.auth"]

        info[:user_name] = user_info[:info][:nickname]
        info[:gender] = user_info[:info][:gender] == '男' ? 1 : 0
        info[:avatar] = user_info[:info][:figureurl_2]
        info[:location] = ''

        info[:uid] = user_info[:uid]
        info[:url] = ''

      end

      user = User.new
      provider = Provider.new

      user.from_provider = true
      user.user_name = info[:user_name]
      user.extra2 = provider_name + info[:uid].to_s
      user.remote_avatar_url = info[:avatar]
      user.gender = info[:gender]
      user.extra1 = info[:location]
      user.save

      provider.user_id = user.id
      provider.provider = provider_name
      provider.uid = info[:uid]
      provider.url = info[:url]
      provider.save

      session[:user_id] = user.id
      redirect_to complete_info_accounts_path
    end

  end

  def oauth_failure
    flash[:notice] = t :auth_failure
    redirect_to login_accounts_path
  end
end
