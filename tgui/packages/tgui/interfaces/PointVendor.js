import { classes } from 'common/react';
import { useBackend } from '../backend';
import { Box, Button, Section, Table } from '../components';
import { Window } from '../layouts';

export const PointVendor = (props, context) => {
  const { act, data } = useBackend(context);
  let inventory = [
    ...data.inventory,
  ];
  return (
    <Window
      width={425}
      height={600}>
      <Window.Content scrollable>
        <Section title="User">
          {data.user && (
            <Box>
              Welcome, <b>{data.user.name || "Unknown"}</b>,
              {' '}
              <b>{data.user.job || "Unemployed"}</b>!
              <br />
              Your balance is <b>{data.user.points} {data.dept} points </b>
              and <b> {data.user.credits} credits</b>.
            </Box>
          ) || (
            <Box color="light-gray">
              No registered ID card!<br />
              Please contact your local HoP!
            </Box>
          )}
        </Section>
        <Section title="Equipment">
          <Table>
            {inventory.map((product => {
              return (
                <Table.Row key={product.name}>
                  <Table.Cell>
                    <b>{data.amounts[product.path]}</b>
                    <span
                      className={classes(['vending32x32', product.icon])}
                      style={{
                        'vertical-align': 'middle',
                      }} />
                    {' '}<b>{product.name}</b>
                  </Table.Cell>
                  <Table.Cell>
                    <Button
                      style={{
                        'min-width': '80px',
                        'text-align': 'center',
                      }}
                      disabled={!data.user
                        || product.points > data.user.points
                        || data.amounts[product.path] <= 0}
                      content={product.points + ' points'}
                      onClick={() => act('purchase', {
                        'type': "points",
                        'path': product.path,
                      })} />
                  </Table.Cell>
                  <Table.Cell>
                    <Button
                      style={{
                        'min-width': '80px',
                        'text-align': 'center',
                      }}
                      disabled={!data.user
                        || product.credits > data.user.credits
                        || data.amounts[product.path] <= 0}
                      content={product.credits + ' credits'}
                      onClick={() => act('purchase', {
                        'type': "credits",
                        'path': product.path,
                      })} />
                  </Table.Cell>
                </Table.Row>
              );
            }))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
