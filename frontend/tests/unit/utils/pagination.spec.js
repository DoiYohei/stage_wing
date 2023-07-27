import { sliceContentsForShow } from "@/utils/pagination";

describe("sliceContentsForShow", () => {
  it("returns sliced contents", () => {
    const contents = [
      { id: 1, name: "event1" },
      { id: 2, name: "event2" },
      { id: 3, name: "event3" },
      { id: 4, name: "event4" },
      { id: 5, name: "event5" },
      { id: 6, name: "event6" },
      { id: 7, name: "event7" },
      { id: 8, name: "event8" },
      { id: 9, name: "event9" },
      { id: 10, name: "event10" },
    ];
    const page = 2;
    const rows = 3;
    const slicedContents = sliceContentsForShow(contents, page, rows);
    expect(slicedContents).toEqual([
      { id: 4, name: "event4" },
      { id: 5, name: "event5" },
      { id: 6, name: "event6" },
    ]);
  });
});
