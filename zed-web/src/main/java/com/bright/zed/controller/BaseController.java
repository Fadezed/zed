package com.bright.zed.controller;

import com.bright.zed.MapCache;
import com.bright.zed.common.TaleUtils;
import com.bright.zed.model.vo.UserVo;

import javax.servlet.http.HttpServletRequest;

/**
 * @author zed
 */
public abstract class BaseController {

    public static String THEME = "themes/default";

    protected MapCache cache = MapCache.single();

    /**
     * 主页的页面主题
     * @param viewName view Name
     * @return str
     */
    public String render(String viewName) {
        return THEME + "/" + viewName;
    }

    public BaseController title(HttpServletRequest request, String title) {
        request.setAttribute("title", title);
        return this;
    }

    public BaseController keywords(HttpServletRequest request, String keywords) {
        request.setAttribute("keywords", keywords);
        return this;
    }

    /**
     * 获取请求绑定的登录对象
     * @param request re
     * @return user
     */
    public UserVo user(HttpServletRequest request) {
        return TaleUtils.getLoginUser(request);
    }

    public Integer getUid(HttpServletRequest request){
        return this.user(request).getUid();
    }

    public String render_404() {
        return "comm/error_404";
    }

}
