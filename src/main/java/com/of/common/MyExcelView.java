package com.of.common;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.view.document.AbstractXlsxView;

@Service("excelView")
public class MyExcelView extends AbstractXlsxView {

	@SuppressWarnings("unchecked")
	@Override
	protected void buildExcelDocument(Map<String, Object> model, Workbook workbook, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String filename = (String) model.get("filename");
		String sheetName = (String) model.get("sheetName");

		List<String> columnLabels = (List<String>) model.get("columnLabels");
		List<Object[]> columnValues = (List<Object[]>) model.get("columnValues");

		response.setContentType("application/ms-excel");
		response.setHeader("Content-disposition", "attachment;filename=" + filename);

		Sheet sheet = createSheet(workbook, 0, sheetName);
		createColumnLabel(sheet, columnLabels);
		createColumnValue(sheet, columnValues);

	}

	// sheet 생성
	private Sheet createSheet(Workbook book, int sheetIdx, String sheetName) {
		Sheet sheet = book.createSheet();

		book.setSheetName(sheetIdx, sheetName);

		return sheet;
	}

	// 제목
	private void createColumnLabel(Sheet sheet, List<String> titles) {
		Row row = sheet.createRow(0);
		Cell cell;
		for (int i = 0; i < titles.size(); i++) {
			sheet.setColumnWidth(i, 256 * 15); // 컬럼 폭

			cell = row.createCell(i);
			cell.setCellValue(titles.get(i));
		}
	}

	// 내용
	private void createColumnValue(Sheet sheet, List<Object[]> values) {
		Row row;
		Cell cell;

		for (int i = 0; i < values.size(); i++) {
			row = sheet.createRow(i + 1);

			Object[] oo = values.get(i);
			for (int col = 0; col < oo.length; col++) {
				try {
					cell = row.createCell(col);
					if (oo[col] instanceof Short) {
						cell.setCellValue((Short) oo[col]);
					} else if (oo[col] instanceof Integer) {
						cell.setCellValue((Integer) oo[col]);
					} else if (oo[col] instanceof Long) {
						cell.setCellValue((Long) oo[col]);
					} else if (oo[col] instanceof Float) {
						cell.setCellValue((Float) oo[col]);
					} else if (oo[col] instanceof Double) {
						cell.setCellValue((Double) oo[col]);
					} else if (oo[col] instanceof Character) {
						cell.setCellValue((Character) oo[col]);
					} else if (oo[col] instanceof Boolean) {
						cell.setCellValue((Boolean) oo[col]);
					} else if (oo[col] instanceof String) {
						cell.setCellValue((String) oo[col]);
					} else {
						cell.setCellValue(oo[col].toString());
					}
				} catch(Exception e) {
					
				}
				
			}
		}
	}

}
