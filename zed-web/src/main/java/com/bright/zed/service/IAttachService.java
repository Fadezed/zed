package com.bright.zed.service;


import com.bright.zed.model.Vo.AttachVo;
import com.github.pagehelper.PageInfo;

/**
 * @author zed
 */
public interface IAttachService {
    /**
     * 分页查询附件
     * @param page page
     * @param limit limit
     * @return t
     */
    PageInfo<AttachVo> getAttachs(Integer page, Integer limit);

    /**
     * 保存附件
     *
     * @param fname f
     * @param fkey f
     * @param ftype f
     * @param author a
     */
    void save(String fname, String fkey, String ftype, Integer author);

    /**
     * 根据附件id查询附件
     * @param id id
     * @return a
     */
    AttachVo selectById(Integer id);

    /**
     * 删除附件
     * @param id id
     */
    void deleteById(Integer id);
}
