import { useBackend, useLocalState } from '../backend';
import { Button, Section, Stack, Tabs, NoticeBox, Input, Box, LabeledList, Collapsible } from '../components';
import { NtosWindow } from '../layouts';

export const NtosImplantController = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    PC_device_theme,
    managers,
  } = data;
  const [
    selectedMGR,
    setSelectedMGR,
  ] = useLocalState(context, 'MGRID', -1);

  return (
    <NtosWindow
      theme={PC_device_theme}
      width={600}
      height={600}
    >
      <NtosWindow.Content>
        {managers.length !== 0
          && (
            <Stack fill>
              <Stack.Item minWidth="105px" shrink={0} basis={0}>
                <Section scrollable fill>
                  <Tabs vertical scrollable >
                    {managers.map(mgr => (
                      <Tabs.Tab
                        key={mgr.id}
                        selected={mgr.id === selectedMGR.id}
                        onClick={() => setSelectedMGR(mgr)}>
                        ID: {mgr.id}
                      </Tabs.Tab>
                    ))}
                  </Tabs>
                </Section>
              </Stack.Item>
              <Stack.Divider />
              <Stack.Item grow={1} basis={0}>
                <Section scrollable fill>
                  {selectedMGR === -1 && (
                    <NoticeBox>
                      Select an ID from the list on the left to proceed.
                    </NoticeBox>) || (
                    <Stack vertical>
                      <Collapsible
                        title="Add New Filter"
                        color="green"
                      ><NewFilterBase mgr={selectedMGR} />
                      </Collapsible>
                      {selectedMGR.filters.map(filter => (
                        <Filter
                          key={selectedMGR.filters.indexOf(filter)}
                          // i know this is stupid but i just
                          // cant seem to get key inside of Filter
                          // for whatever reason
                          index={selectedMGR.filters.indexOf(filter)}
                          filter={filter}
                          selMGR={selectedMGR} />
                      ))}
                    </Stack>
                  )}
                </Section>
              </Stack.Item>
            </Stack>
          ) || (
          <NoticeBox>No active WordBlock implants detected.</NoticeBox>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const Filter = (props, context) => {
  const { filter, selMGR, index } = props;
  const { act, data } = useBackend(context);
  const {
    managers,
  } = data;

  const [
    selectedMGR,
    setSelectedMGR,
  ] = useLocalState(context, 'MGRID', -1);

  const refresh = () => {
    setSelectedMGR(-1);
    setSelectedMGR(selMGR);
  };

  // super hacky sorry
  const VisualSwap = (a, b) => {
    let {
      filtered_word,
      replacement_word,
      case_sensitive,
      replace,
      active,
    } = a;

    a.filtered_word = b.filtered_word;
    a.replacement_word = b.replacement_word;
    a.case_sensitive = b.case_sensitive;
    a.replace = b.replace;
    a.active = b.active;

    b.filtered_word = filtered_word;
    b.replacement_word = replacement_word;
    b.case_sensitive = case_sensitive;
    b.replace = replace;
    b.active = active;

  };

  return (
    <Stack.Item>
      <Section title={"Filter"}
        buttons={
          (
            <Box>
              {index !== 0 && (
                <Button
                  icon="angle-up"
                  onClick={() => {
                    act('PRG_movefilter', {
                      mgrID: selMGR.id,
                      filterID: index,
                      direction: "up",
                    });
                    refresh();
                    VisualSwap(selMGR.filters[index], selMGR.filters[index-1]);
                  }}
                />
              )}
              {index !== (selMGR.filters.length-1) && (
                <Button
                  icon="angle-down"
                  onClick={() => {
                    act('PRG_movefilter', {
                      mgrID: selMGR.id,
                      filterID: index,
                      direction: "down",
                    });
                    refresh();
                    VisualSwap(selMGR.filters[index], selMGR.filters[index+1]);
                  }}
                />
              )}
              <Button
                color="red"
                icon="trash"
                onClick={() => {
                  act('PRG_removefilter', {
                    mgrID: selMGR.id,
                    filterID: index,
                  });
                  refresh();
                  selMGR.filters.splice(index, 1);
                }}
              />
            </Box>)
        }>
        <Stack fill>
          <Stack.Item>
            <LabeledList>
              <LabeledList.Item label="Filter">
                <Input
                  value={filter.filtered_word}
                  onChange={(e, value) => act('PRG_setfiltered', {
                    newFiltered: value,
                    mgrID: selMGR.id,
                    filterID: index,
                  })} />
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
          <Stack.Item>
            <LabeledList>
              <LabeledList.Item label="Replace">
                {filter.replace && (
                  <Input
                    value={filter.replacement_word}
                    onChange={(e, value) => act('PRG_setfilter', {
                      newFilter: value,
                      mgrID: selMGR.id,
                      filterID: index,
                    })} />
                ) || ("No replacement")}
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
        </Stack>
        <Stack>
          <Stack.Item width="33%">
            <Button.Checkbox fluid
              content="Enabled"
              checked={filter.active}
              onClick={() => {
                act('PRG_toggleactive', {
                  mgrID: selMGR.id,
                  filterID: index,
                });
                filter.active = !filter.active;
              }}
            />
          </Stack.Item>
          <Stack.Item width="33%">
            <Button.Checkbox fluid
              content="Case Sensitive"
              checked={filter.case_sensitive}
              onClick={() => {
                act('PRG_togglecasesens', {
                  mgrID: selMGR.id,
                  filterID: index,
                });
                filter.case_sensitive = !filter.case_sensitive;
              }}
            />
          </Stack.Item>
          <Stack.Item width="33%">
            <Button.Checkbox fluid
              content="Replace"
              checked={filter.replace}
              onClick={() => {
                act('PRG_togglereplace', {
                  mgrID: selMGR.id,
                  filterID: index,
                });
                filter.replace = !filter.replace;
              }}
            />
          </Stack.Item>
        </Stack>
      </Section>
    </Stack.Item>
  );
};

const NewFilterBase = (props, context) => {
  const { act, data } = useBackend(context);
  const { mgr } = props;
  const [
    newFiltered,
    setNewFiltered,
  ] = useLocalState(context, "newfiltered", "Sample");
  const [
    newReplacement,
    setNewReplacement,
  ] = useLocalState(context, "newreplacement", "elpmaS");
  const [
    newActive,
    setNewActive,
  ] = useLocalState(context, "newactive", 1);
  const [
    newCaseSensitive,
    setNewCaseSensitive,
  ] = useLocalState(context, "newcasesensitive", 0);
  const [
    newReplace,
    setNewReplace,
  ] = useLocalState(context, "newreplace", 1);
  const [
    selectedMGR,
    setSelectedMGR,
  ] = useLocalState(context, 'MGRID', -1);
  return (
    <Stack.Item>
      <Section>
        <Stack fill>
          <Stack.Item>
            <LabeledList>
              <LabeledList.Item label="Filter">
                <Input
                  value={newFiltered}
                  onChange={(e, value) => setNewFiltered(value)} />
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
          <Stack.Item>
            <LabeledList>
              <LabeledList.Item label="Replace">
                {newReplace && (
                  <Input
                    value={newReplacement}
                    onChange={(e, value) => setNewReplacement(value)} />
                ) || ("No replacement")}
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
        </Stack>
        <Stack>
          <Stack.Item width="33%">
            <Button.Checkbox fluid
              content="Enabled"
              checked={newActive}
              onClick={() => setNewActive(Number(!newActive))}
            />
          </Stack.Item>
          <Stack.Item width="33%">
            <Button.Checkbox fluid
              content="Case Sensitive"
              checked={newCaseSensitive}
              onClick={() => setNewCaseSensitive(Number(!newCaseSensitive))}
            />
          </Stack.Item>
          <Stack.Item width="33%">
            <Button.Checkbox fluid
              content="Replace"
              checked={newReplace}
              onClick={() => setNewReplace(Number(!newReplace))}
            />
          </Stack.Item>
        </Stack>
        <Button
          content="Confirm Addition"
          icon="plus"
          onClick={() => {
            act('PRG_addfilter', {
              filtered: newFiltered,
              replacement: newReplacement,
              active: newActive,
              replace: newReplace,
              case_sensitive: newCaseSensitive,
              mgrID: mgr.id,
            });

            // bad hack: by the time we redraw
            // the screen the filter is not yet
            // added byond-side (or maybe it is)
            // (and we don't know) so I have to add
            // a "fake" one to make the user experience better
            mgr.filters.push({
              filtered_word: newFiltered,
              replacement_word: newReplacement,
              case_sensitive: newCaseSensitive,
              replace: newReplace,
              active: newActive,
            });

            // reset to defaults
            setNewFiltered("Sample");
            setNewReplacement("elpmaS");
            setNewActive(1);
            setNewCaseSensitive(0);
            setNewReplace(1);

            // bad hack to redraw screen
            setSelectedMGR(-1);
            setSelectedMGR(mgr);
          }}
        />
      </Section>
    </Stack.Item>
  );
};
