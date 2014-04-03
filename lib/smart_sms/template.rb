module SmartSMS
  module Template
    extend self
    def find_default tpl_id = ''
      Request.post 'tpl/get_default.json', tpl_id: tpl_id
    end

    def find tpl_id = ''
      Request.post 'tpl/get.json', tpl_id: tpl_id
    end

    def create tpl_content = ''
      Request.post 'tpl/add.json', tpl_content: tpl_content
    end

    def update tpl_id = '', tpl_content = ''
      Request.post 'tpl/update.json', tpl_id: tpl_id, tpl_content: tpl_content
    end

    def destroy tpl_id = ''
      Request.post 'tpl/del.json', tpl_id: tpl_id
    end
  end
end