class SearchResultsController < ApplicationController
	autocomplete :search_result, :record_string, full: true, extra_data: [:record_type, :record_id]
end
