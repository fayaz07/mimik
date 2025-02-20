/* eslint-disable no-plusplus */
/* eslint-disable no-unused-vars */
import React from "react";

import Pagination from "react-bootstrap/Pagination";

interface PaginationProps {
  max: number;
  current: number;
  onPageChange: (current: number) => void;
}

function calculatePagination(
  currentPage: number,
  totalPages: number
): { startPage: number; endPage: number } {
  let startPage: number;
  let endPage: number;
  const maxPagesToShow = 7;
  const halfMaxPagesToShow = Math.floor(maxPagesToShow / 2);

  if (totalPages <= maxPagesToShow) {
    // show all pages
    startPage = 1;
    endPage = totalPages;
  } else if (currentPage - halfMaxPagesToShow <= 0) {
    // show first maxPagesToShow pages
    startPage = 1;
    endPage = maxPagesToShow;
  } else if (currentPage + halfMaxPagesToShow >= totalPages) {
    // show last maxPagesToShow pages
    startPage = totalPages - maxPagesToShow + 1;
    endPage = totalPages;
  } else {
    // show pages on both sides of current page
    startPage = currentPage - halfMaxPagesToShow;
    endPage = currentPage + halfMaxPagesToShow;
  }

  return { startPage, endPage };
}

function AppPagination({ max, current, onPageChange }: PaginationProps) {
  const arr = [];

  const updatePage = (p: number) => {
    onPageChange(p);
  };

  const { startPage, endPage } = calculatePagination(current, max);

  for (let index = startPage; index <= endPage; index++) {
    arr.push(
      <Pagination.Item
        key={`${index}-page`}
        active={current === index}
        onClick={() => updatePage(index)}
      >
        {index}
      </Pagination.Item>
    );
  }

  if (endPage < max) {
    arr.push(<Pagination.Ellipsis />);
  }

  return (
    <Pagination>
      <Pagination.First onClick={() => updatePage(1)} />
      <Pagination.Prev
        onClick={() => {
          if (current > 1) {
            updatePage(current - 1);
          }
        }}
      />
      {arr}
      <Pagination.Next
        onClick={() => {
          if (current < max) {
            updatePage(current + 1);
          }
        }}
      />
      <Pagination.Last onClick={() => updatePage(max)} />
    </Pagination>
  );
}

export default AppPagination;
