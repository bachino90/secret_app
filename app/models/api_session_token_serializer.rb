class ApiSessionTokenSerializer < ActiveModel::MongoidSerializer
  attributes :token, http_status
end