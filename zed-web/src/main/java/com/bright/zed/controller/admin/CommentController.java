package com.bright.zed.controller.admin;

import com.bright.zed.common.TaleUtils;
import com.bright.zed.controller.BaseController;
import com.bright.zed.exception.TipException;
import com.bright.zed.model.bo.RestResponseBo;
import com.bright.zed.model.vo.CommentVo;
import com.bright.zed.model.vo.CommentVoExample;
import com.bright.zed.model.vo.UserVo;
import com.bright.zed.service.ICommentService;
import com.github.pagehelper.PageInfo;
import com.vdurmont.emoji.EmojiParser;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

/**
 * 评论
 * @author zed
 */
@Slf4j
@Controller
@RequestMapping("back/comments")
public class CommentController extends BaseController {


    @Resource
    private ICommentService commentsService;

    /**
     * 评论列表
     * @param page page
     * @param limit limit
     * @param request re
     * @return str
     */
    @GetMapping(value = "")
    public String index(@RequestParam(value = "page", defaultValue = "1") int page,
                        @RequestParam(value = "limit", defaultValue = "15") int limit, HttpServletRequest request) {
        UserVo users = this.user(request);
        CommentVoExample commentVoExample = new CommentVoExample();
        commentVoExample.setOrderByClause("coid desc");
        commentVoExample.createCriteria().andAuthorIdNotEqualTo(users.getUid());
        PageInfo<CommentVo> comments = commentsService.getCommentsWithPage(commentVoExample,page, limit);
        request.setAttribute("comments", comments);
        return "admin/comment_list";
    }

    /**
     * 删除一条评论
     * @param commentId s c
     * @return s
     */
    @PostMapping(value = "delete")
    @ResponseBody
    @Transactional(rollbackFor = TipException.class)
    public RestResponseBo delete(@RequestParam Integer commentId) {
        try {
            CommentVo comments = commentsService.getCommentById(commentId);
            if(null == comments){
                return RestResponseBo.fail("不存在该评论");
            }
            commentsService.delete(commentId, comments.getCid());
        } catch (Exception e) {
            String msg = "评论删除失败";
            if (e instanceof TipException) {
                msg = e.getMessage();
            } else {
                log.error(msg, e);
            }
            return RestResponseBo.fail(msg);
        }
        return RestResponseBo.ok();
    }

    @PostMapping(value = "status")
    @ResponseBody
    @Transactional(rollbackFor = TipException.class)
    public RestResponseBo delete(@RequestParam Integer coid, @RequestParam String status) {
        try {
            CommentVo comments = new CommentVo();
            comments.setCoid(coid);
            comments.setStatus(status);
            commentsService.update(comments);
        } catch (Exception e) {
            String msg = "操作失败";
            if (e instanceof TipException) {
                msg = e.getMessage();
            } else {
                log.error(msg, e);
            }
            return RestResponseBo.fail(msg);
        }
        return RestResponseBo.ok();
    }

    /**
     * 回复评论
     * @param coid c
     * @param content content
     * @param request re
     * @return s
     */
    @PostMapping(value = "")
    @ResponseBody
    @Transactional(rollbackFor = TipException.class)
    public RestResponseBo reply(@RequestParam Integer coid, @RequestParam String content, HttpServletRequest request) {
        if(null == coid || StringUtils.isBlank(content)){
            return RestResponseBo.fail("请输入完整后评论");
        }

        if(content.length() > 2000){
            return RestResponseBo.fail("请输入2000个字符以内的回复");
        }
        CommentVo c = commentsService.getCommentById(coid);
        if(null == c){
            return RestResponseBo.fail("不存在该评论");
        }
        UserVo users = this.user(request);
        content = TaleUtils.cleanXSS(content);
        content = EmojiParser.parseToAliases(content);

        CommentVo comments = new CommentVo();
        comments.setAuthor(users.getUsername());
        comments.setAuthorId(users.getUid());
        comments.setCid(c.getCid());
        comments.setIp(request.getRemoteAddr());
        comments.setUrl(users.getHomeUrl());
        comments.setContent(content);
        comments.setMail(users.getEmail());
        comments.setParent(coid);
        try {
            commentsService.insertComment(comments);
            return RestResponseBo.ok();
        } catch (Exception e) {
            String msg = "回复失败";
            if (e instanceof TipException) {
                msg = e.getMessage();
            } else {
                log.error(msg, e);
            }
            return RestResponseBo.fail(msg);
        }
    }

}
