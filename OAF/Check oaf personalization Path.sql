SELECT PATH.PATH_DOCID PERZ_DOC_ID,
jdr_mds_internal.getdocumentname(PATH.PATH_DOCID) PERZ_DOC_PATH
FROM JDR_PATHS PATH
WHERE PATH.PATH_DOCID IN
(SELECT DISTINCT COMP_DOCID FROM JDR_COMPONENTS
WHERE COMP_SEQ = 0 AND COMP_ELEMENT = 'customization' 
AND COMP_ID IS NULL)
AND   upper(jdr_mds_internal.getdocumentname(path_docid) ) LIKE upper('%XxReqLinesNotifRN%')
ORDER BY PERZ_DOC_PATH;