package com.bright.zed.controller.admin;

import com.bright.zed.constant.WebConst;
import com.bright.zed.controller.BaseController;
import com.bright.zed.dto.MetaDto;
import com.bright.zed.dto.Types;
import com.bright.zed.exception.TipException;
import com.bright.zed.model.bo.RestResponseBo;
import com.bright.zed.service.IMetaService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * 分类
 * @author zed
 */
@Slf4j
@Controller
@RequestMapping("back/category")
public class CategoryController extends BaseController {

    @Resource
    private IMetaService metasService;

    /**
     * 分类页
     * @param request re
     * @return str
     */
    @GetMapping(value = "")
    public String index(HttpServletRequest request) {
        List<MetaDto> categories = metasService.getMetaList(Types.CATEGORY.getType(), null, WebConst.MAX_POSTS);
        List<MetaDto> tags = metasService.getMetaList(Types.TAG.getType(),  null, WebConst.MAX_POSTS);
        request.setAttribute("categories", categories);
        request.setAttribute("tags", tags);
        return "admin/category";
    }

    @PostMapping(value = "save")
    @ResponseBody
    @Transactional(rollbackFor = TipException.class)
    public RestResponseBo saveCategory(@RequestParam String cname, @RequestParam Integer mid) {
        try {
            metasService.saveMeta(Types.CATEGORY.getType(),cname,mid);
        } catch (Exception e) {
            String msg = "分类保存失败";
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
     * 删除分类
     * @param mid mid
     * @return s
     */
    @RequestMapping(value = "delete")
    @ResponseBody
    @Transactional(rollbackFor = TipException.class)
    public RestResponseBo delete(@RequestParam int mid) {
        try {
            metasService.delete(mid);
        } catch (Exception e) {
            String msg = "删除失败";
            if (e instanceof TipException) {
                msg = e.getMessage();
            } else {
                log.error(msg, e);
            }
            return RestResponseBo.fail(msg);
        }
        return RestResponseBo.ok();
    }

}
