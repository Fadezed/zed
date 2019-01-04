package com.bright.zed.dao;

import com.bright.zed.model.vo.UserVo;
import com.bright.zed.model.vo.UserVoExample;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface UserVoMapper {
    long countByExample(UserVoExample example);

    int deleteByExample(UserVoExample example);

    int deleteByPrimaryKey(Integer uid);

    int insert(UserVo record);

    int insertSelective(UserVo record);

    List<UserVo> selectByExample(UserVoExample example);

    UserVo selectByPrimaryKey(Integer uid);

    int updateByExampleSelective(@Param("record") UserVo record, @Param("example") UserVoExample example);

    int updateByExample(@Param("record") UserVo record, @Param("example") UserVoExample example);

    int updateByPrimaryKeySelective(UserVo record);

    int updateByPrimaryKey(UserVo record);
}