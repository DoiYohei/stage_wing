import { 
  popFutureItems,
  sortDatesByEarliestToLatest,
  sortDatesByLatestToEarliest,
  narrowDownNames,
  narrowDownDates,
} from "@/utils/searches";

describe("popFutureItems", () => {
  it("returns future's and today's item", () => {
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const futureItems = [
      { date: today },
      { date: new Date(today.getTime() + 86400000) },
      { date: new Date(today.getTime() + 86400000 * 2) },
    ];
    const allItems = [
      ...futureItems,
      { date: new Date(today.getTime() - 86400000) },
      { date: new Date(today.getTime() - 86400000 * 2) },
    ];
    expect(popFutureItems(allItems)).toEqual(futureItems);
  });
});

describe("sortDatesByEarliestToLatest", () => {
  it("returns items sorted by date from earliest to latest", () => {
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const items = [
      { date: new Date(today.getTime() + 86400000 * 2) },
      { date: new Date(today.getTime() + 86400000) },
      { date: today },
    ];
    const sortedItems = [
      { date: today },
      { date: new Date(today.getTime() + 86400000) },
      { date: new Date(today.getTime() + 86400000 * 2) },
    ];
    expect(sortDatesByEarliestToLatest(items)).toEqual(sortedItems);
  });
});

describe("sortDatesByLatestToEarliest", () => {
  it("returns items sorted by date from latest to earliest", () => {
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const items = [
      { date: today },
      { date: new Date(today.getTime() + 86400000) },
      { date: new Date(today.getTime() + 86400000 * 2) },
    ];
    const sortedItems = [
      { date: new Date(today.getTime() + 86400000 * 2) },
      { date: new Date(today.getTime() + 86400000) },
      { date: today },
    ];
    expect(sortDatesByLatestToEarliest(items)).toEqual(sortedItems);
  });
});

describe("narrowDownNames", () => {
  it("returns items narrowed down by name", () => {
    const items = [
      { name: "item1" },
      { name: "item1item2" },
      { name: "item2" },
      { name: "item2item3" },
      { name: "item3" },
      { name: "item3item1" },
    ];
    const keyword = "item2";
    const narrowedItems = [
      { name: "item1item2" },
      { name: "item2" },
      { name: "item2item3" },
    ];
    expect(narrowDownNames(keyword, items)).toEqual(narrowedItems);
  });
});

describe("narrowDownDates", () => {
  it("returns items narrowed down by date", () => {
    const items = [
      { date: "2020-01-01" },
      { date: "2020-01-02" },
      { date: "2020-01-03" },
      { date: "2020-01-04" },
      { date: "2020-01-05" },
      { date: "2020-01-06" },
    ];
    const keyword = "2020-01-02";
    const narrowedItems = [
      { date: "2020-01-02" },
    ];
    expect(narrowDownDates(keyword, items)).toEqual(narrowedItems);
  });
});
