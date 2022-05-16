import { useBackend, useLocalState, useSharedState } from '../backend';
import { Button, Icon, Flex, NumberInput, Section, Box, NoticeBox } from '../components';
import { Window } from '../layouts';

export const ATM = (props, context) => {
  const { act, data } = useBackend(context);
  const [
    amount,
    setAmount,
  ] = useLocalState(context, 'amount', 0);
  const [
    selected,
    setSelected,
  ] = useSharedState(context, 'selected', 0);
  const pointTypes = Object.keys(data.rates);
  return (
    <Window
      width={275}
      height={103}>
      <Window.Content>
        <Flex>
          <Flex.Item>
            <Button
              color="good"
              icon="arrow-left"
              onClick={() => setSelected(Math.max(selected - 1, 0))} />
          </Flex.Item>
          <Flex.Item grow={1}>
            <Box textAlign="center">
              {Object.keys(data.rates)[selected]}
            </Box>
          </Flex.Item>
          <Flex.Item>
            <Button
              color="good"
              icon="arrow-right"
              onClick={() =>
                setSelected(
                  Math.min(selected + 1, pointTypes.length - 1))} />
          </Flex.Item>
        </Flex>
        <Section>
          {(!!data.card) && (
            <Flex>
              <Flex.Item grow={1}>
                <NumberInput
                  width="80px"
                  value={amount}
                  minValue={0}
                  maxValue={data.points[pointTypes[selected]]}
                  onDrag={(e, value) => setAmount(value)} />
                <Icon ml={0.5} mr={1} name="arrow-right" />
                {amount * data.rates[pointTypes[selected]] + " cr"}
              </Flex.Item>
              <Flex.Item>
                <Button
                  color="good"
                  icon="check"
                  onClick={() => act('convert', { amount: amount,
                    selected: pointTypes[selected] })} />
              </Flex.Item>
            </Flex>
          ) || (<NoticeBox>No ID card detected.</NoticeBox>)}
        </Section>
      </Window.Content>
    </Window>
  );
};
