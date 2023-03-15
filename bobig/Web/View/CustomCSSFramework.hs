module Web.View.CustomCSSFramework(customBootstrap) where

import IHP.HSX.QQ (hsx)
import IHP.HSX.ToHtml ()
import IHP.Prelude
import IHP.View.Classes
import IHP.View.CSSFramework
import IHP.View.Types
import Text.Blaze ((!))
import qualified Text.Blaze.Html5 as Blaze
import qualified Text.Blaze.Html5.Attributes as Blaze

import IHP.Pagination.Types

import Debug.Trace

customBootstrap = bootstrap
  { styledPaginationItemsPerPageSelector = itemsPerPageSelector }
  where
      itemsPerPageSelector _ pagination@Pagination {pageSize} itemsPerPageUrl =
          let oneOption n =
                  [hsx|
                      <option value={show n} selected={n == pageSize}
                              data-url={itemsPerPageUrl n}>
                        {n} items per page
                      </option>|]
              stdOptions = [10,20,50,100,200]
              options =
                  if elem pageSize stdOptions
                    then stdOptions
                    else sort $ pageSize : stdOptions
           in [hsx|{forEach options oneOption}|]
