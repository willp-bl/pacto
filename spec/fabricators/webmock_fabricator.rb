# -*- encoding : utf-8 -*-
# Fabricators for WebMock objects

Fabricator(:webmock_request_signature, from: WebMock::RequestSignature) do
  initialize_with do
    uri = _transient_attributes[:uri]
    method = _transient_attributes[:method]
    uri = Addressable::URI.heuristic_parse(uri) unless uri.is_a? Addressable::URI
    WebMock::RequestSignature.new method, uri
  end
  transient method: :get
  transient uri: 'www.example.com'
end

Fabricator(:webmock_request_pattern, from: Pacto::RequestPattern) do
  initialize_with do
    uri = _transient_attributes[:uri]
    method = _transient_attributes[:method]
    uri = Addressable::URI.heuristic_parse(uri) unless uri.is_a? Addressable::URI
    Pacto::RequestPattern.new method, uri
  end
  transient method: :get
  transient uri: 'www.example.com'
end
