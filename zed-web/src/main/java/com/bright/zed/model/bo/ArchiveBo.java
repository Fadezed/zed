package com.bright.zed.model.bo;


import com.bright.zed.model.vo.ContentVo;
import lombok.Data;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;

/**
 * 描述:
 * 档案
 *
 * @author zed
 * @since 2019-01-02 8:21 PM
 */
@Data
@ToString
public class ArchiveBo implements Serializable {
    /**
     * 时间
     */
    private String date;
    /**
     * cout
     */
    private String count;
    /**
     * 文章列表
     */
    private List<ContentVo> articles;

}
