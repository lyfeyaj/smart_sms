# encoding: utf-8

module SmartSMS
  # module that handle `Template`
  module Template
    module_function

    # 取默认模板
    # Options:
    #
    #   * tpl_id: 指定tpl_id时返回tpl_id对应的默认模板. 未指定时返回所有默认模板
    #
    def find_default(tpl_id = '')
      Request.post 'tpl/get_default.json', tpl_id: tpl_id
    end

    # 取自定义模板
    # Options:
    #
    #   * tpl_id: 指定tpl_id时返回tpl_id对应的自定义模板. 未指定时返回所有自定义模板
    #
    def find(tpl_id = '')
      Request.post 'tpl/get.json', tpl_id: tpl_id
    end

    # 创建新模板
    # 规则请参见: <http://www.yunpian.com/api/tpl.html>
    #
    def create(tpl_content = '')
      Request.post 'tpl/add.json', tpl_content: tpl_content
    end

    # 更新模板, 需指定id和content
    #
    def update(tpl_id = '', tpl_content = '')
      Request.post 'tpl/update.json', tpl_id: tpl_id, tpl_content: tpl_content
    end

    # 删除模板, 需指定id
    def destroy(tpl_id = '')
      Request.post 'tpl/del.json', tpl_id: tpl_id
    end
  end
end
