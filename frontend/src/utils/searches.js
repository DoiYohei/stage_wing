export const popFutureItems = (allItems) => {
  // 今日のitemはfutureItemsに含める
  const now = new Date();
  const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  const futureItems = allItems.filter((item) => {
    return today.getTime() <= new Date(item.date).getTime();
  });
  return futureItems;
};

export const sortDatesByEarliestToLatest = (items) => {
  return items.sort((a, b) => new Date(a.date) - new Date(b.date));
};

export const sortDatesByLatestToEarliest = (items) => {
  return items.sort((a, b) => new Date(b.date) - new Date(a.date));
};

export const narrowDownNames = (input, items) => {
  const keyword = input ? input.toLowerCase().trim() : "";
  return items.filter((item) => item.name.toLowerCase().includes(keyword));
};

export const narrowDownDates = (input, items) => {
  return items.filter((item) => item.date.includes(input));
};
